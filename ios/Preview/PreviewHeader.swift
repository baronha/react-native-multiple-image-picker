import UIKit

protocol PreviewHeaderViewDelegate: AnyObject {
    func headerView(_ headerView: PreviewHeaderView, didPressClearButton button: UIButton)
    func headerView(_ headerView: PreviewHeaderView, didPressDoneButton button: UIButton)
}

class PreviewHeaderView: UIView {
    weak var viewDelegate: PreviewHeaderViewDelegate?

    lazy var clearButton: UIButton = {
        let image = UIImage.close.resize(to: .init(width: 18, height: 18))

        let button = UIButton(type: .custom)

        button.setImage(image, for: .normal)

        button.addTarget(self, action: #selector(PreviewHeaderView.clearAction(button:)), for: .touchUpInside)

        return button
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(config.doneTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        button.addTarget(self, action: #selector(PreviewHeaderView.doneAction(button:)), for: .touchUpInside)

//        button.backgroundColor = config.selectedColor

//        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
//
//        button.layer.cornerRadius = 6.0

//        button.setContentHuggingPriority(.required, for: .vertical)
//        button.setContentCompressionResistancePriority(.required, for: .vertical)

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

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
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
