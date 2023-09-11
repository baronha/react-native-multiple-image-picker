import UIKit

protocol ViewableControllerContainer {}

protocol ViewableControllerContainerDataSource: class {
    func numberOfPagesInViewableControllerContainer(_ viewableControllerContainer: ViewableControllerContainer) -> Int
    func viewableControllerContainer(_ viewableControllerContainer: ViewableControllerContainer, controllerAtIndex index: Int) -> UIViewController
}

protocol ViewableControllerContainerDelegate: class {
    func viewableControllerContainer(_ viewableControllerContainer: ViewableControllerContainer, didMoveToIndex index: Int)
    func viewableControllerContainer(_ viewableControllerContainer: ViewableControllerContainer, didMoveFromIndex index: Int)
}

