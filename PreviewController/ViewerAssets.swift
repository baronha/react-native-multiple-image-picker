import UIKit

class ViewerAssets {
    static let bundle = Bundle(for: ViewerAssets.self)
}

extension UIImage {
    static var darkCircle = UIImage(name: "dark-circle")
    static var pause = UIImage(name: "pause")
    static var play = UIImage(name: "play")
    static var `repeat` = UIImage(name: "repeat")
    static var seek = UIImage(name: "seek")
    public static var close = UIImage(name: "close")

    convenience init(name: String) {
        self.init(named: name, in: ViewerAssets.bundle, compatibleWith: nil)!
    }
}
