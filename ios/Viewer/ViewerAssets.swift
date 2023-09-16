import UIKit

class ViewerAssets {
    class func bundle() -> Bundle {
        let podBundle = Bundle(for: ViewerAssets.self)
        if let url = podBundle.url(forResource: "Viewer", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return bundle ?? podBundle
        }
        return podBundle
    }
}

extension UIImage {
    static var darkCircle = UIImage(name: "dark-circle")
    static var pause = UIImage(name: "pause")
    static var play = UIImage(name: "play")
    static var `repeat` = UIImage(name: "repeat")
    static var seek = UIImage(name: "seek")
    public static var close = UIImage(name: "close")

    convenience init(name: String) {
        self.init(named: name, in: ViewerAssets.bundle(), compatibleWith: nil)!
    }
}
