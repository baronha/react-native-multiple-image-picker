import UIKit

protocol PreviewHeaderViewDelegate: AnyObject {
    func headerView(_ headerView: PreviewHeaderView, didPressClearButton button: UIButton)
    func headerView(_ headerView: PreviewHeaderView, didPressDoneButton button: UIButton)
}

class PreviewHeaderView: UIView {
    weak var viewDelegate: PreviewHeaderViewDelegate?
    static let ButtonSize = CGFloat(24.0)
    static let TopMargin = CGFloat(15.0)

    lazy var clearButton: UIButton = {
        let image = UIImage.close

        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(PreviewHeaderView.clearAction(button:)), for: .touchUpInside)

        return button
    }()

    lazy var doneButton: UIButton = {
        let image = UIImage.play

        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(PreviewHeaderView.clearAction(button:)), for: .touchUpInside)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing // Đặt phân bố để căn chỉnh giữa
        addSubview(stackView)

        // Tạo hai UIView là các mục trong header row
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.clearButton)

        self.doneButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.doneButton)

        // Đặt constraints cho stack view để căn chỉnh theo phía trái và phải
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @objc func clearAction(button: UIButton) {
        self.viewDelegate?.headerView(self, didPressClearButton: button)
    }

    @objc func doneAction(button: UIButton) {
        self.viewDelegate?.headerView(self, didPressDoneButton: button)
    }
}
