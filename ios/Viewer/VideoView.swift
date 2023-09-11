import UIKit
import AVFoundation
import AVKit

#if os(iOS)
    import Photos
#endif

protocol VideoViewDelegate: class {
    func videoViewDidStartPlaying(_ videoView: VideoView)
    func videoView(_ videoView: VideoView, didChangeProgress progress: Double, duration: Double)
    func videoViewDidFinishPlaying(_ videoView: VideoView, error: NSError?)
}

class VideoView: UIView {
    static let playerItemStatusKeyPath = "status"
    static let audioSessionVolumeKeyPath = "outputVolume"
    weak var delegate: VideoViewDelegate?
    var playerCurrentItemStatus = AVPlayerItem.Status.unknown

    fileprivate lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()

        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        return playerLayer
    }()

    var image: UIImage?

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]

        return view
    }()

    private lazy var loadingIndicatorBackground: UIImageView = {
        let view = UIImageView(image: .darkCircle)
        view.alpha = 0

        return view
    }()

    fileprivate var shouldRegisterForStatusNotifications = true
    fileprivate var shouldRegisterForFailureOrEndingNotifications = true
    fileprivate var shouldRegisterForOutputVolume = true

    fileprivate var playbackProgressTimeObserver: Any?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        self.isUserInteractionEnabled = false
        self.layer.addSublayer(self.playerLayer)
        self.addSubview(self.loadingIndicatorBackground)
        self.addSubview(self.loadingIndicator)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Proposed workaround to fix some issues with observers called after being deallocated.
    // Error description:
    // Fatal Exception: NSInternalInconsistencyException
    // An instance 0x15ed87220 of class AVPlayerItem was deallocated while key value observers were still registered with it.
    deinit {
        self.removeBeforePlayingObservers()
        self.removeWhilePlayingObservers()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let image = self.image else { return }
        self.frame = image.centeredFrame()

        var playerLayerFrame = image.centeredFrame()
        playerLayerFrame.origin.x = 0
        playerLayerFrame.origin.y = 0
        self.playerLayer.frame = playerLayerFrame

        let loadingBackgroundHeight = self.loadingIndicatorBackground.frame.size.height
        let loadingBackgroundWidth = self.loadingIndicatorBackground.frame.size.width
        self.loadingIndicatorBackground.frame = CGRect(x: (self.frame.size.width - loadingBackgroundWidth) / 2, y: (self.frame.size.height - loadingBackgroundHeight) / 2, width: loadingBackgroundWidth, height: loadingBackgroundHeight)

        let loadingHeight = self.loadingIndicator.frame.size.height
        let loadingWidth = self.loadingIndicator.frame.size.width
        self.loadingIndicator.frame = CGRect(x: (self.frame.size.width - loadingWidth) / 2, y: (self.frame.size.height - loadingHeight) / 2, width: loadingWidth, height: loadingHeight)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {

        if keyPath == VideoView.audioSessionVolumeKeyPath {
            #if os(iOS)
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            #endif
            return
        }

        guard let playerItem = object as? AVPlayerItem else { return }
        self.playerCurrentItemStatus = playerItem.status

        if let error = playerItem.error {
            self.handleError(error as NSError)
        } else {
            guard let player = self.playerLayer.player else {
                let error = NSError(domain: ViewerController.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Player not found."])
                self.handleError(error)
                return
            }
            guard keyPath == VideoView.playerItemStatusKeyPath else { return }
            guard playerItem.status == .readyToPlay else { return }

            self.playerLayer.player?.pause()
            self.removeBeforePlayingObservers()

            if self.playerLayer.isHidden == false {
                player.play()
                self.delegate?.videoViewDidStartPlaying(self)
            }

            if let playbackProgressTimeObserver = self.playbackProgressTimeObserver {
                player.removeTimeObserver(playbackProgressTimeObserver)
                self.playbackProgressTimeObserver = nil
            }

            let interval = CMTime(seconds: 1 / 60, preferredTimescale: Int32(NSEC_PER_SEC))
            self.playbackProgressTimeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: nil) { _ in
                self.loadingIndicator.stopAnimating()
                self.loadingIndicatorBackground.alpha = 0

                let duration = CMTimeGetSeconds(playerItem.asset.duration)
                let currentTime = CMTimeGetSeconds(player.currentTime())
                // In some cases the video will start playing with negative current time.
                if currentTime > 0 {
                    self.delegate?.videoView(self, didChangeProgress: currentTime, duration: duration)
                }
            }
        }
    }

    func handleError(_ error: NSError) {
        self.playerLayer.player?.pause()
        self.removeBeforePlayingObservers()
        self.removeWhilePlayingObservers()
        self.delegate?.videoViewDidFinishPlaying(self, error: error as NSError?)
    }

    func prepare(using viewable: Viewable, completion: @escaping () -> Void) {
        self.addPlayer(using: viewable) {
            if self.shouldRegisterForStatusNotifications {
                guard let player = self.playerLayer.player else { return }
                guard let currentItem = player.currentItem else { return }

                self.shouldRegisterForStatusNotifications = false
                currentItem.addObserver(self, forKeyPath: VideoView.playerItemStatusKeyPath, options: [], context: nil)

                do {
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setActive(true)
                    audioSession.addObserver(self, forKeyPath: VideoView.audioSessionVolumeKeyPath, options: .new, context: nil)
                    self.shouldRegisterForOutputVolume = false
                } catch {
                    print("Failed to activate audio session")
                }
            }

            if self.shouldRegisterForFailureOrEndingNotifications {
                self.shouldRegisterForFailureOrEndingNotifications = false
                NotificationCenter.default.addObserver(self, selector: #selector(self.videoFinishedPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.itemPlaybackStalled), name: .AVPlayerItemPlaybackStalled, object: nil)
            }

            completion()
        }
    }

    func `repeat`() {
        self.playerLayer.player?.seek(to: CMTime.zero)
        self.playerLayer.player?.play()
    }

    func stop() {
        self.removeBeforePlayingObservers()
        self.removeWhilePlayingObservers()

        self.playerLayer.isHidden = true
        self.playerLayer.player?.pause()
        self.playerLayer.player?.seek(to: CMTime.zero)
        self.playerLayer.player = nil

        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default, options: [])
        #endif
    }

    func play() {
        guard let player = self.playerLayer.player else {
            let error = NSError(domain: ViewerController.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "No player was found."])
            self.handleError(error)
            return
        }

        if player.status == .unknown {
            self.loadingIndicator.startAnimating()
            self.loadingIndicatorBackground.alpha = 1
        }

        self.playerLayer.player?.play()
        self.playerLayer.isHidden = false
    }

    func pause() {
        self.playerLayer.player?.pause()
    }

    func isPlaying() -> Bool {
        if let player = self.playerLayer.player {
            let isPlaying = player.rate != 0 && player.error == nil
            return isPlaying
        }

        return false
    }

    // Source:
    // Technical Q&A QA1820
    // How do I achieve smooth video scrubbing with AVPlayer seekToTime:?
    // https://developer.apple.com/library/content/qa/qa1820/_index.html
    var isSeekInProgress = false
    var chaseTime = CMTime.zero

    func stopPlayingAndSeekSmoothlyToTime(duration: Double) {
        guard let timescale = self.playerLayer.player?.currentItem?.currentTime().timescale else { return }
        let newChaseTime = CMTime(seconds: duration, preferredTimescale: timescale)
        self.playerLayer.player?.pause()

        if CMTimeCompare(newChaseTime, self.chaseTime) != 0 {
            self.chaseTime = newChaseTime

            if self.isSeekInProgress == false {
                self.trySeekToChaseTime()
            }
        }
    }

    func trySeekToChaseTime() {
        switch self.playerCurrentItemStatus {
        case .unknown:
            // wait until item becomes ready (KVO player.currentItem.status)
            break
        case .readyToPlay:
            self.actuallySeekToTime()
        case .failed:
            break
        @unknown default:
            break
        }
    }

    func actuallySeekToTime() {
        self.isSeekInProgress = true
        let seekTimeInProgress = self.chaseTime
        self.playerLayer.player?.seek(to: seekTimeInProgress, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { _ in
            if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.isSeekInProgress = false
            } else {
                self.trySeekToChaseTime()
            }
        }
    }
}

extension VideoView {

    fileprivate func addPlayer(using viewable: Viewable, completion: @escaping () -> Void) {
        if let assetID = viewable.assetID {
            #if os(iOS)
                let result = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
                guard let asset = result.firstObject else {
                    let error = NSError(domain: ViewerController.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't get asset for id: \(assetID)."])
                    self.handleError(error)
                    return
                }
                let requestOptions = PHVideoRequestOptions()
                requestOptions.isNetworkAccessAllowed = true
                PHImageManager.default().requestPlayerItem(forVideo: asset, options: requestOptions) { playerItem, info in
                    guard let playerItem = playerItem else {
                        let error = NSError(domain: ViewerController.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't create player: \(String(describing: info))."])
                        self.handleError(error)
                        return
                    }

                    if let player = self.playerLayer.player {
                        player.replaceCurrentItem(with: playerItem)
                    } else {
                        let player = AVPlayer(playerItem: playerItem)
                        player.rate = Float(playerItem.preferredPeakBitRate)
                        self.playerLayer.player = player
                        self.playerLayer.isHidden = true
                    }

                    DispatchQueue.main.async {
                        completion()
                    }
                }
            #endif
        } else if let url = viewable.url {
            DispatchQueue.global(qos: .background).async {
                let streamingURL = URL(string: url)!
                self.playerLayer.player = AVPlayer(url: streamingURL)
                self.playerLayer.isHidden = true

                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    fileprivate func removeBeforePlayingObservers() {
        if self.shouldRegisterForStatusNotifications == false {
            guard let player = self.playerLayer.player else { return }
            guard let currentItem = player.currentItem else { return }

            self.shouldRegisterForStatusNotifications = true
            currentItem.removeObserver(self, forKeyPath: VideoView.playerItemStatusKeyPath)
        }
    }

    fileprivate func removeWhilePlayingObservers() {
        if let playbackProgressTimeObserver = self.playbackProgressTimeObserver {
            self.playerLayer.player?.removeTimeObserver(playbackProgressTimeObserver)
            self.playbackProgressTimeObserver = nil
        }

        if self.shouldRegisterForFailureOrEndingNotifications == false {
            self.shouldRegisterForFailureOrEndingNotifications = true

            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemPlaybackStalled, object: nil)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        }

        if self.shouldRegisterForOutputVolume == false {
            self.shouldRegisterForOutputVolume = true
            AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: VideoView.audioSessionVolumeKeyPath)
        }
    }

    // When the video is having troubles buffering it might trigger the "AVPlayerItemPlaybackStalled" notification
    // the ideal scenario here, is that we'll pause the video, display the loading indicator for a while,
    // then continue the play back.
    // The current workaround just pauses the video and tries to play again, this might cause a shuddering video playback,
    // is not perfect but does the job for now.
    @objc fileprivate func itemPlaybackStalled() {
        if let player = self.playerLayer.player {
            player.pause()
            player.play()
        }
    }

    @objc fileprivate func videoFinishedPlaying() {
        self.delegate?.videoViewDidFinishPlaying(self, error: nil)
    }
}

extension CMTime {
    public init(seconds: Double, preferredTimescale: CMTimeScale) {
        self = CMTimeMakeWithSeconds(seconds, preferredTimescale: preferredTimescale)
    }
}
