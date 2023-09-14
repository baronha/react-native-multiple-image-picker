import UIKit

protocol PreviewHeaderViewDelegate: AnyObject {
    func headerView(_ headerView: PreviewHeaderView, didPressClearButton button: UIButton)
    func headerView(_ headerView: PreviewHeaderView, didPressDoneButton button: UIButton)
}

class PreviewHeaderView: UIView {
    weak var viewDelegate: PreviewHeaderViewDelegate?

    lazy var clearButton: UIButton = {
        let image = UIImage.close.setTintColor(.black)?.resize(to: .init(width: 18, height: 18))

        let button = UIButton(type: .custom)

        button.setImage(image, for: .normal)

        button.addTarget(self, action: #selector(PreviewHeaderView.clearAction(button:)), for: .touchUpInside)

        return button
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system) // Sử dụng type .system cho button với giao diện người dùng tiêu chuẩn

        // Đặt tiêu đề (text) cho button
        button.setTitle(config.doneTitle, for: .normal)

        // Đặt màu chữ và màu nền cho button (tuỳ chọn)
        button.setTitleColor(config.selectedColor, for: .normal)

        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)

        button.addTarget(self, action: #selector(PreviewHeaderView.doneAction(button:)), for: .touchUpInside)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white

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
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
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
