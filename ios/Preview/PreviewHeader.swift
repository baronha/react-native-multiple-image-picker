import UIKit

protocol PreviewHeaderViewDelegate: AnyObject {
    func headerView(_ headerView: PreviewHeaderView, didPressClearButton button: UIButton)
    func headerView(_ headerView: PreviewHeaderView, didPressDoneButton button: UIButton)
}

class PreviewHeaderView: UIView {
    weak var viewDelegate: PreviewHeaderViewDelegate?

    lazy var clearButton: UIButton = {
        let image = UIImage.close

        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)

        // Đặt kích thước cho hình ảnh bên trong button
        let imageSize = CGSize(width: 24, height: 24) // Đặt kích thước mới cho hình ảnh
        button.imageView?.frame = CGRect(origin: CGPoint.zero, size: imageSize)

        button.frame = CGRect(x: 50, y: 100, width: imageSize.width, height: imageSize.height)

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

        if #available(iOS 11.0, *) {
            self.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        }

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
