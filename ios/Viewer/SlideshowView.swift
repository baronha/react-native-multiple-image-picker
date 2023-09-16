import UIKit


/// The current implementation of SlideshowVideo will ignore videos, if a video is the initially presented element then
/// it will instantly jump to the next element. If the next element is a video it will continue jumping until a photo
/// is found.
class SlideshowView: UIView, ViewableControllerContainer {
    weak var dataSource: ViewableControllerContainerDataSource?
    weak var delegate: ViewableControllerContainerDelegate?

    fileprivate static let fadeDuration: Double = 1
    fileprivate static let transitionToNextDuration: Double = 6
    fileprivate unowned var parentController: UIViewController
    fileprivate var currentPage: Int
    fileprivate var currentController: ViewableController?

    fileprivate lazy var timer: Timer = {
        let timer = Timer(timeInterval: SlideshowView.transitionToNextDuration, target: self, selector: #selector(loadNext), userInfo: nil, repeats: true)

        return timer
    }()

    init(frame: CGRect, parentController: UIViewController, initialPage: Int) {
        self.parentController = parentController
        self.currentPage = initialPage

        super.init(frame: frame)

        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        self.loadPage(self.currentPage, isInitial: true)

        if self.isVideo(at: self.currentPage) {
            self.loadNext()
        }
    }

    func start() {
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
    }

    func stop() {
        self.timer.invalidate()
    }
}

extension SlideshowView {
    fileprivate func loadPage(_ page: Int, isInitial: Bool) {
        if page >= self.numberOfPages || page < 0 {
            return
        }

        guard let controller = self.dataSource?.viewableControllerContainer(self, controllerAtIndex: page) as? ViewableController else { return }
        guard let image = controller.viewable?.placeholder else { return }

        controller.view.frame = image.centeredFrame()
        self.parentController.addChild(controller)
        self.addSubview(controller.view)
        controller.didMove(toParent: self.parentController)

        if isInitial {
            self.currentController = controller
        } else {
            self.delegate?.viewableControllerContainer(self, didMoveFromIndex: self.currentPage)
            self.delegate?.viewableControllerContainer(self, didMoveToIndex: page)

            controller.view.alpha = 0
            UIView.animate(withDuration: SlideshowView.fadeDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                self.currentController?.view.alpha = 0
                controller.view.alpha = 1
            }, completion: { isFinished in
                self.currentController?.willMove(toParent: nil)
                self.currentController?.view.removeFromSuperview()
                self.currentController?.removeFromParent()
                self.currentController = nil

                self.currentController = controller

                self.currentPage = page
            })
        }
    }

    @objc func loadNext() {
        var newPage = self.currentPage + 1
        guard newPage <= self.numberOfPages else { return }

        let hasReachedEnd = newPage == self.numberOfPages
        if hasReachedEnd {
            newPage = 0
        }

        if self.isVideo(at: newPage) {
            self.currentPage = newPage
            self.loadNext()
        } else {
            self.loadPage(newPage, isInitial: false)
        }
    }


    fileprivate func isVideo(at index: Int) -> Bool {
        if let controller = self.dataSource?.viewableControllerContainer(self, controllerAtIndex: index) as? ViewableController {
            return controller.viewable?.type == .video
        }

        return false
    }

    fileprivate var numberOfPages: Int {
        return self.dataSource?.numberOfPagesInViewableControllerContainer(self) ?? 0
    }
}
