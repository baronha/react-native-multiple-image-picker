//
//  PreviewFooter.swift
//  react-native-multiple-image-picker
//
//  Created by BẢO HÀ on 15/09/2023.
//

import TLPhotoPicker
import UIKit

protocol PreviewFooterViewDelegate: AnyObject {
    func footerView(_ headerView: PreviewFooterView, didPressSelectButton button: SelectButton)
}

class SelectButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame.size = .init(width: 24, height: 24)

        backgroundColor = .clear

        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor

        layer.cornerRadius = 16
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)

        translatesAutoresizingMaskIntoConstraints = false
    }

    @objc open var selectedAsset: Bool = false {
        willSet(newValue) {
            backgroundColor = config.selectedColor
            if !newValue {
                backgroundColor = .clear
                setTitle("", for: .normal)
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PreviewFooterView: UIView {
    weak var viewDelegate: PreviewFooterViewDelegate?
    var selectButton: SelectButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView()

        selectButton = SelectButton()

        selectButton.addTarget(self, action: #selector(PreviewFooterView.selectAction(button:)), for: .touchUpInside)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        addSubview(stackView)

        selectButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(selectButton)

        selectButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        selectButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true

        // (Tuỳ chọn) Đặt constraints cho chiều rộng và chiều cao của UIButton
        selectButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 32).isActive = true

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

    @objc func selectAction(button: SelectButton) {
        viewDelegate?.footerView(self, didPressSelectButton: button)
    }
}
