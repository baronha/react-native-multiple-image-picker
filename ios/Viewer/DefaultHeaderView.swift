import UIKit

protocol DefaultHeaderViewDelegate: class {
    func headerView(_ headerView: DefaultHeaderView, didPressClearButton button: UIButton)
}

class DefaultHeaderView: UIView {
    weak var delegate: DefaultHeaderViewDelegate?
    static let ButtonSize = CGFloat(50.0)
    static let TopMargin = CGFloat(14.0)

    lazy var clearButton: UIButton = {
        let image = UIImage.close
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(DefaultHeaderView.clearAction(button:)), for: .touchUpInside)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.clearButton)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.clearButton.frame = CGRect(x: 4, y: DefaultHeaderView.TopMargin, width: DefaultHeaderView.ButtonSize, height: DefaultHeaderView.ButtonSize)
    }

    @objc func clearAction(button: UIButton) {
        self.delegate?.headerView(self, didPressClearButton: button)
    }
}
