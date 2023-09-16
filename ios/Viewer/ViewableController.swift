import AVFoundation
import AVKit
import UIKit

#if os(iOS)
    import Photos
#endif

protocol ViewableControllerDelegate: class {
    func viewableControllerDidTapItem(_ viewableController: ViewableController)
    func viewableController(_ viewableController: ViewableController, didFailDisplayingVieweableWith error: NSError)
}

protocol ViewableControllerDataSource: class {
    func viewableControllerOverlayIsVisible(_ viewableController: ViewableController) -> Bool
    func viewableControllerIsFocused(_ viewableController: ViewableController) -> Bool
    func viewableControllerShouldAutoplayVideo(_ viewableController: ViewableController) -> Bool
}

class ViewableController: UIViewController {
    static let playerItemStatusKeyPath = "status"
    private static let FooterViewHeight = CGFloat(50.0)

    weak var delegate: ViewableControllerDelegate?
    weak var dataSource: ViewableControllerDataSource?

    lazy var zoomingScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = self.maxZoomScale()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if #available(iOS 11.0, tvOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }

        return scrollView
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = true

        return view
    }()

    lazy var imageLoadingIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true

        return activityView
    }()

    lazy var videoView: VideoView = {
        let view = VideoView()
        view.delegate = self

        return view
    }()

    lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.play
        button.setImage(image, for: UIControl.State())
        button.alpha = 0

        #if os(tvOS)
            // Disable user interaction on play button to allow drag to dismiss video thumb on tvOS
            button.isUserInteractionEnabled = false
        #else
            button.addTarget(self, action: #selector(ViewableController.playAction), for: .touchUpInside)
        #endif

        return button
    }()

    lazy var repeatButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.repeat
        button.setImage(image, for: UIControl.State())
        button.alpha = 0
        button.addTarget(self, action: #selector(ViewableController.repeatAction), for: .touchUpInside)

        return button
    }()

    lazy var pauseButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.pause
        button.setImage(image, for: UIControl.State())
        button.alpha = 0
        button.addTarget(self, action: #selector(ViewableController.pauseAction), for: .touchUpInside)

        return button
    }()

    lazy var videoProgressView: VideoProgressView = {
        let progressView = VideoProgressView(frame: .zero)
        progressView.alpha = 0
        progressView.delegate = self

        return progressView
    }()

    var changed = false
    var viewable: Viewable?
    var indexPath: IndexPath?

    var viewableBackgroundColor: UIColor = .black

    var playerViewController: AVPlayerViewController?

    var hasZoomed: Bool {
        return self.zoomingScrollView.zoomScale != 1.0
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.videoFinishedPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        self.playerViewController?.player?.currentItem?.removeObserver(self, forKeyPath: ViewableController.playerItemStatusKeyPath, context: nil)
        self.playerViewController = nil
    }

    func update(with viewable: Viewable, at indexPath: IndexPath) {
        if self.indexPath?.description != indexPath.description {
            self.changed = true
        }

        if self.changed {
            self.indexPath = indexPath
            self.viewable = viewable
            self.videoView.image = viewable.placeholder
            self.imageView.image = viewable.placeholder
            self.videoView.frame = viewable.placeholder.centeredFrame()
            self.changed = false
        }
    }

    func maxZoomScale() -> CGFloat {
        guard let image = self.imageView.image else { return 1 }

        var widthFactor = CGFloat(1.0)
        var heightFactor = CGFloat(1.0)
        if image.size.width > self.view.bounds.width {
            widthFactor = image.size.width / self.view.bounds.width
        }
        if image.size.height > self.view.bounds.height {
            heightFactor = image.size.height / self.view.bounds.height
        }

        return max(3.0, max(widthFactor, heightFactor))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = self.viewableBackgroundColor

        self.zoomingScrollView.addSubview(self.imageView)
        self.view.addSubview(self.zoomingScrollView)
        self.view.addSubview(self.imageLoadingIndicator)

        self.view.addSubview(self.videoView)

        self.view.addSubview(self.playButton)
        self.view.addSubview(self.repeatButton)
        self.view.addSubview(self.pauseButton)
        self.view.addSubview(self.videoProgressView)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewableController.tapAction))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)

        if self.viewable?.type == .image {
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewableController.doubleTapAction))
            doubleTapRecognizer.numberOfTapsRequired = 2
            self.zoomingScrollView.addGestureRecognizer(doubleTapRecognizer)

            tapRecognizer.require(toFail: doubleTapRecognizer)
        }
    }

    // In iOS 10 going into landscape provides a very strange animation. Basically you'll see the other
    // viewer items animating on top of the focused one. Horrible. This is a workaround that hides the
    // non-visible viewer items to avoid that. Also we hide the placeholder image view (zoomingScrollView)
    // because it was animating at a different timing than the video view and it looks bad.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let viewable = self.viewable else { return }

        let isFocused = self.dataSource?.viewableControllerIsFocused(self)
        if viewable.type == .video || isFocused == false {
            self.view.backgroundColor = .clear
            self.zoomingScrollView.isHidden = true
        }
        coordinator.animate(alongsideTransition: { _ in

        }) { _ in
            if viewable.type == .video || isFocused == false {
                self.view.backgroundColor = .black
                self.zoomingScrollView.isHidden = false
            }

            self.configure()
        }
    }

    @objc func tapAction() {
        if self.videoView.isPlaying() {
            UIView.animate(withDuration: 0.3, animations: {
                self.pauseButton.alpha = self.pauseButton.alpha == 0 ? 1 : 0
                self.videoProgressView.alpha = self.videoProgressView.alpha == 0 ? 1 : 0
            })
        }

        self.delegate?.viewableControllerDidTapItem(self)
    }

    @objc func doubleTapAction(recognizer: UITapGestureRecognizer) {
        let zoomScale = self.zoomingScrollView.zoomScale == 1 ? self.maxZoomScale() : 1

        let touchPoint = recognizer.location(in: self.imageView)

        let scrollViewSize = self.imageView.bounds.size

        let width = scrollViewSize.width / zoomScale
        let height = scrollViewSize.height / zoomScale
        let originX = touchPoint.x - (width / 2.0)
        let originY = touchPoint.y - (height / 2.0)

        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)

        self.zoomingScrollView.zoom(to: rectToZoomTo, animated: true)
    }

    func play() {
        if !self.videoView.isPlaying() {
            self.playAction()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let buttonImage = UIImage.play
        let buttonHeight = buttonImage.size.height
        let buttonWidth = buttonImage.size.width
        self.playButton.frame = CGRect(x: (self.view.frame.size.width - buttonWidth) / 2, y: (self.view.frame.size.height - buttonHeight) / 2, width: buttonHeight, height: buttonHeight)
        self.repeatButton.frame = CGRect(x: (self.view.frame.size.width - buttonWidth) / 2, y: (self.view.frame.size.height - buttonHeight) / 2, width: buttonHeight, height: buttonHeight)
        self.pauseButton.frame = CGRect(x: (self.view.frame.size.width - buttonWidth) / 2, y: (self.view.frame.size.height - buttonHeight) / 2, width: buttonHeight, height: buttonHeight)

        self.videoProgressView.frame = CGRect(x: 0, y: self.view.frame.height - ViewableController.FooterViewHeight - VideoProgressView.height, width: self.view.frame.width, height: VideoProgressView.height)
    }

    func willDismiss() {
        guard let viewable = self.viewable else { return }

        if viewable.type == .video {
            self.videoView.stop()
            self.resetButtonStates()
        }

        UIView.animate(withDuration: 0.3) {
            self.zoomingScrollView.zoomScale = 1
        }
    }

    func display() {
        guard let viewable = self.viewable else { return }

        switch viewable.type {
        case .image:
            // Needed to avoid showing the loading indicator for a fraction of a second. Thanks to this the
            // loading indicator will only be displayed when the image is taking a lot of time to load.
            let deadline = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                if self.imageView.image == nil {
                    self.imageLoadingIndicator.startAnimating()
                }
            }

            viewable.media { image, _ in
                DispatchQueue.main.async {
                    self.imageLoadingIndicator.stopAnimating()
                    if let image = image {
                        self.imageView.image = image
                        self.configure()
                    }
                }
            }
        case .video:
            #if os(iOS)
                let shouldAutoplayVideo = self.dataSource?.viewableControllerShouldAutoplayVideo(self) ?? false
                if !shouldAutoplayVideo {
                    viewable.media { image, _ in
                        DispatchQueue.main.async {
                            if let image = image {
                                self.imageView.image = image
                            }
                        }
                    }
                }

                self.videoView.prepare(using: viewable) {
                    if shouldAutoplayVideo {
                        self.videoView.play()
                    } else {
                        self.playButton.alpha = 1
                    }
                }
            #else
                // If there's currently a `AVPlayerViewController` we want to reuse it and create a new `AVPlayer`.
                // One of the reasons to do this is because we found a failure in our playback because it was an expired
                // link and we renewed the link and want the video to play again.
                if let playerViewController = self.playerViewController {
                    playerViewController.player?.currentItem?.removeObserver(self, forKeyPath: ViewableController.playerItemStatusKeyPath, context: nil)

                    if let urlString = self.viewable?.url, let url = URL(string: urlString) {
                        let playerItem = AVPlayerItem(url: url)
                        playerViewController.player?.replaceCurrentItem(with: playerItem)

                        guard let currentItem = playerViewController.player?.currentItem else { return }
                        currentItem.addObserver(self, forKeyPath: ViewableController.playerItemStatusKeyPath, options: [], context: nil)
                    }
                } else {
                    viewable.media { image, _ in
                        DispatchQueue.main.async {
                            if let image = image {
                                self.imageView.image = image
                                self.playButton.alpha = 1
                            }
                        }
                    }
                }
            #endif
        }
    }

    func resetButtonStates() {
        self.repeatButton.alpha = 0
        self.pauseButton.alpha = 0
        self.videoProgressView.alpha = 0

        let shouldAutoplayVideo = self.dataSource?.viewableControllerShouldAutoplayVideo(self) ?? false
        if !shouldAutoplayVideo {
            self.playButton.alpha = 1
        }
    }

    @objc func pauseAction() {
        self.repeatButton.alpha = 0
        self.pauseButton.alpha = 0
        self.playButton.alpha = 1
        self.videoProgressView.alpha = 1

        self.videoView.pause()
    }

    @objc func playAction() {
        #if os(iOS)
            self.repeatButton.alpha = 0
            self.pauseButton.alpha = 0
            self.playButton.alpha = 0
            self.videoProgressView.alpha = 0

            self.videoView.play()
            self.requestToHideOverlayIfNeeded()
        #else
            // We use the native video player in Apple TV because it provides us extra functionality that is not
            // provided in the custom player while at the same time it doesn't decrease the user experience since
            // it's not expected that the user will drag the video to dismiss it, something that we need to do on iOS.
            if let url = self.viewable?.url {
                self.playerViewController?.player?.currentItem?.removeObserver(self, forKeyPath: ViewableController.playerItemStatusKeyPath, context: nil)
                self.playerViewController = nil

                self.playerViewController = AVPlayerViewController(nibName: nil, bundle: nil)
                self.playerViewController?.player = AVPlayer(url: URL(string: url)!)

                guard let currentItem = self.playerViewController?.player?.currentItem else { return }
                currentItem.addObserver(self, forKeyPath: ViewableController.playerItemStatusKeyPath, options: [], context: nil)

                self.present(self.playerViewController!, animated: true) {
                    self.playerViewController!.player?.play()
                }
            }
        #endif
    }

    func configure() {
        self.zoomingScrollView.maximumZoomScale = self.maxZoomScale()

        let viewFrame = self.view.frame
        let zoomScale = self.zoomingScrollView.zoomScale
        let frame = CGRect(x: viewFrame.origin.x,
                           y: viewFrame.origin.y,
                           width: zoomScale * viewFrame.width,
                           height: zoomScale * viewFrame.height)

        self.zoomingScrollView.contentSize = frame.size
        self.imageView.frame = frame
        self.configureImageView()
    }

    func configureImageView() {
        guard let image = imageView.image else {
            self.centerImageView()
            return
        }

        let imageViewSize = self.imageView.frame.size
        let imageSize = image.size
        let realImageViewSize: CGSize

        if imageSize.width / imageSize.height > imageViewSize.width / imageViewSize.height {
            realImageViewSize = CGSize(
                width: imageViewSize.width,
                height: imageViewSize.width / imageSize.width * imageSize.height)
        } else {
            realImageViewSize = CGSize(
                width: imageViewSize.height / imageSize.height * imageSize.width,
                height: imageViewSize.height)
        }

        self.imageView.frame = CGRect(origin: CGPoint.zero, size: realImageViewSize)

        self.centerImageView()
    }

    func centerImageView() {
        let boundsSize = self.view.frame.size
        var imageViewFrame = self.imageView.frame

        if imageViewFrame.size.width < boundsSize.width {
            imageViewFrame.origin.x = (boundsSize.width - imageViewFrame.size.width) / 2.0
        } else {
            imageViewFrame.origin.x = 0.0
        }

        if imageViewFrame.size.height < boundsSize.height {
            imageViewFrame.origin.y = (boundsSize.height - imageViewFrame.size.height) / 2.0
        } else {
            imageViewFrame.origin.y = 0.0
        }

        self.imageView.frame = imageViewFrame
    }

    @objc func videoFinishedPlaying() {
        #if os(tvOS)
            guard let player = self.playerViewController?.player else { return }
            player.pause()
            self.playerViewController?.dismiss(animated: false, completion: nil)
        #endif
    }

    override func observeValue(forKeyPath _: String?, of object: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }

        if let error = playerItem.error {
            self.handleVideoPlaybackError(error as NSError)
        }
    }

    func handleVideoPlaybackError(_ error: NSError) {
        self.delegate?.viewableController(self, didFailDisplayingVieweableWith: error)
    }

    @objc func repeatAction() {
        self.repeatButton.alpha = 0

        let overlayIsVisible = self.dataSource?.viewableControllerOverlayIsVisible(self) ?? false
        if overlayIsVisible {
            self.pauseButton.alpha = 1
            self.videoProgressView.alpha = 1
        } else {
            self.videoProgressView.alpha = 0
        }

        self.videoView.repeat()
    }

    func requestToHideOverlayIfNeeded() {
        let overlayIsVisible = self.dataSource?.viewableControllerOverlayIsVisible(self) ?? false
        if overlayIsVisible {
            self.delegate?.viewableControllerDidTapItem(self)
        }
    }

    var shouldDimPause: Bool = false
    var shouldDimPlay: Bool = false
    var shouldDimVideoProgress: Bool = false

    func dimControls(_ alpha: CGFloat) {
        if self.pauseButton.alpha == 1.0 {
            self.shouldDimPause = true
        }

        if self.playButton.alpha == 1.0 {
            self.shouldDimPlay = true
        }

        if self.videoProgressView.alpha == 1.0 {
            self.shouldDimVideoProgress = true
        }

        if self.shouldDimPause {
            self.pauseButton.alpha = alpha
        }

        if self.shouldDimPlay {
            self.playButton.alpha = alpha
        }

        if self.shouldDimVideoProgress {
            self.videoProgressView.alpha = alpha
        }

        if alpha == 1.0 {
            self.shouldDimPause = false
            self.shouldDimPlay = false
            self.shouldDimVideoProgress = false
        }
    }
}

extension ViewableController: UIScrollViewDelegate {
    func viewForZooming(in _: UIScrollView) -> UIView? {
        if self.viewable?.type == .image {
            return self.imageView
        } else {
            return nil
        }
    }

    func scrollViewDidZoom(_: UIScrollView) {
        self.centerImageView()
    }
}

extension ViewableController: VideoViewDelegate {
    func videoViewDidStartPlaying(_: VideoView) {
        self.requestToHideOverlayIfNeeded()
    }

    func videoView(_: VideoView, didChangeProgress progress: Double, duration: Double) {
        self.videoProgressView.progress = progress
        self.videoProgressView.duration = duration
    }

    func videoViewDidFinishPlaying(_: VideoView, error: NSError?) {
        if let error = error {
            self.delegate?.viewableController(self, didFailDisplayingVieweableWith: error)
        } else {
            self.repeatButton.alpha = 1
            self.pauseButton.alpha = 0
            self.playButton.alpha = 0
            self.videoProgressView.alpha = 0
        }
    }
}

extension ViewableController: VideoProgressViewDelegate {
    func videoProgressViewDidBeginSeeking(_: VideoProgressView) {
        self.videoView.pause()
    }

    func videoProgressViewDidSeek(_: VideoProgressView, toDuration duration: Double) {
        self.videoView.stopPlayingAndSeekSmoothlyToTime(duration: duration)
    }

    func videoProgressViewDidEndSeeking(_: VideoProgressView) {
        self.videoView.play()
    }
}
