//
//  Utilities.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/06.
//

import UIKit

class Utilites {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.image = image
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         paddingLeft: 8, paddingBottom: 8,
                         width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: imageView.rightAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor,
                           bottom: view.bottomAnchor,
                           right: view.rightAnchor,
                           height: 0.75)
        
        return view
    }
    
    func makeTwitterTextField(withPlaceHolder placeHolder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeHolder
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    func makeAtrributedButton(_ first: String, _ second: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: first,
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: second,
                                                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                               NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }
}
