//
//  PreviewFooter.swift
//  react-native-multiple-image-picker
//
//  Created by BẢO HÀ on 15/09/2023.
//

import TLPhotoPicker
import UIKit

protocol PreviewFooterViewDelegate: AnyObject {
    func footerView(_ headerView: PreviewFooterView, didPressSelectButton button: UIButton)
}

class PreviewFooterView: TLPhotoCollectionViewCell {
    weak var viewDelegate: PreviewFooterViewDelegate?

    lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)

        button.addTarget(self, action: #selector(PreviewFooterView.selectAction(button:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
//
//        button.layer.cornerRadius = 12
//        button.clipsToBounds = true

        button.backgroundColor = config.selectedColor

        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor

        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        button.setTitle("1", for: .normal)
        button.setTitleColor(.white, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false

        // Tạo constraints để cố định vị trí của tiêu đề ở giữa tuyệt đối (absolute center)

//        let label = UILabel()
//        label.text = "2"
//        label.textColor = UIColor.white // Tuỳ chỉnh màu văn bản theo ý muốn
//        label.textAlignment = .center
//        label.frame = button.bounds // Đặt kích thước và vị trí của UILabel bằng bằng với UIButton
//        button.addSubview(label)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        addSubview(stackView)

        self.selectButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.selectButton)

        self.selectButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        self.selectButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true

        // (Tuỳ chọn) Đặt constraints cho chiều rộng và chiều cao của UIButton
        self.selectButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        self.selectButton.heightAnchor.constraint(equalToConstant: 32).isActive = true

        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @objc func selectAction(button: UIButton) {
        self.viewDelegate?.footerView(self, didPressSelectButton: button)
    }
}
