import UIKit

class PaginatedScrollView: UIScrollView, ViewableControllerContainer {
    weak var viewDataSource: ViewableControllerContainerDataSource?
    weak var viewDelegate: ViewableControllerContainerDelegate?
    fileprivate unowned var parentController: UIViewController
    fileprivate var currentPage: Int
    fileprivate var shoudEvaluate = false

    init(frame: CGRect, parentController: UIViewController, initialPage: Int) {
        self.parentController = parentController
        self.currentPage = initialPage

        super.init(frame: frame)

        #if os(iOS)
            self.isPagingEnabled = true
            self.scrollsToTop = false
        #endif
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        #if os(iOS)
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        #endif
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }

        let numPages = self.viewDataSource?.numberOfPagesInViewableControllerContainer(self) ?? 0
        self.contentSize = CGSize(width: self.frame.size.width * CGFloat(numPages), height: self.frame.size.height)

        self.loadScrollViewWithPage(self.currentPage - 1)
        self.loadScrollViewWithPage(self.currentPage)
        self.loadScrollViewWithPage(self.currentPage + 1)
        self.gotoPage(self.currentPage, animated: false)
    }

    fileprivate func loadScrollViewWithPage(_ page: Int) {
        let numPages = self.viewDataSource?.numberOfPagesInViewableControllerContainer(self) ?? 0
        if page >= numPages || page < 0 {
            return
        }

        if let controller = self.viewDataSource?.viewableControllerContainer(self, controllerAtIndex: page), controller.view.superview == nil {
            var frame = self.frame
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0
            controller.view.frame = frame

            self.parentController.addChild(controller)
            self.addSubview(controller.view)
            controller.didMove(toParent: self.parentController)
        }
    }

    fileprivate func gotoPage(_ page: Int, animated: Bool) {
        self.loadScrollViewWithPage(page - 1)
        self.loadScrollViewWithPage(page)
        self.loadScrollViewWithPage(page + 1)

        var bounds = self.bounds
        bounds.origin.x = bounds.size.width * CGFloat(page)
        bounds.origin.y = 0

            self.scrollRectToVisible(bounds, animated: animated)
    }

    func goRight() {
        let numPages = self.viewDataSource?.numberOfPagesInViewableControllerContainer(self) ?? 0
        let newPage = self.currentPage + 1
        guard newPage <= numPages else { return }

        self.gotoPage(newPage, animated: true)
    }

    func goLeft() {
        let newPage = self.currentPage - 1
        guard newPage >= 0 else { return }

        self.gotoPage(newPage, animated: true)
    }
}

extension PaginatedScrollView: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_: UIScrollView) {
        self.shoudEvaluate = true
    }

    func scrollViewDidEndDecelerating(_: UIScrollView) {
        self.shoudEvaluate = false
    }

    func scrollViewDidScroll(_: UIScrollView) {
        if self.shoudEvaluate {
            let pageWidth = self.frame.size.width
            let page = Int(floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            if page != self.currentPage {
                self.viewDelegate?.viewableControllerContainer(self, didMoveToIndex: page)
                self.viewDelegate?.viewableControllerContainer(self, didMoveFromIndex: self.currentPage)
            }
            self.currentPage = page

            self.loadScrollViewWithPage(page - 1)
            self.loadScrollViewWithPage(page)
            self.loadScrollViewWithPage(page + 1)
        }
    }
}
