//
//  CustomFooterView.swift
//  react-native-multiple-image-picker
//
//  Created by John on 2024/3/19.
//

import UIKit

protocol BottomPreviewButtonDelegate: AnyObject {
    func bottomPreviewButtonTapped()
}


class CustomFooterView: UIView {
    
    public weak var delegate:BottomPreviewButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        addSubview(button)

        // 禁用AutoresizingMask，确保使用Auto Layout
        button.translatesAutoresizingMaskIntoConstraints = false
        // 添加左边距约束：距离左边为20
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        // 添加垂直方向上的居中约束：使按钮在父视图中水平居中
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        button.setTitle("Preview", for: .normal)
        button.setTitleColor(config.selectedColor, for: .normal)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.bottomPreviewButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
