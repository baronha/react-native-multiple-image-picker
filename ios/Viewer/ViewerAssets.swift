import UIKit

class ViewerAssets {
    static let bundle = Bundle(for: ViewerAssets.self)
}

extension UIImage {
    static var darkCircle = MultipleImagePickerBundle.podBundleImage(named: "dark-circle")
    static var pause = MultipleImagePickerBundle.podBundleImage(named: "pause")
    static var play = MultipleImagePickerBundle.podBundleImage(named: "play")
    static var `repeat` = MultipleImagePickerBundle.podBundleImage(named: "repeat")
    static var seek = MultipleImagePickerBundle.podBundleImage(named: "seek")
    public static var close = MultipleImagePickerBundle.podBundleImage(named: "close")

    convenience init(name: String) {
        self.init(named: name, in: MultipleImagePickerBundle.bundle(), compatibleWith: nil)!
    }
}
