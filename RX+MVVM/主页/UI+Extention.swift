//
//  UI+Extention.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/27.
//  Copyright © 2018年 jps. All rights reserved.
//

import Foundation
import UIKit

//https://juejin.im/post/5a6b173c6fb9a01cbf3891b7

//@IBDesignable
extension UIImageView {
    
    //让storyboard里可以直接设置圆角
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    ///可选类型不能直接在storyboard中显示出来
    @IBInspectable var borderColor: CGColor? {
        get {
            return layer.borderColor
        }
        set {
            guard let newValue = newValue else { return }
            layer.borderColor = newValue
        }
    }
    
//    @IBInspectable var borderColor: UIColor = UIColor.white {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
    
    
    
    

    
    @IBInspectable var border_Width: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
}


extension UILabel {
    @IBInspectable var localizedKey: String? {
        set {
            guard let newValue = newValue else { return }
            text = NSLocalizedString(newValue, comment: "")
        }
        get { return text }
    }
    
    
}

extension UIButton {
    @IBInspectable var localizedKey: String? {
        set {
            guard let newValue = newValue else { return }
            setTitle(NSLocalizedString(newValue, comment: ""), for: .normal)
        }
        get { return titleLabel?.text }
    }
}

extension UITextField {
    @IBInspectable var localizedKey: String? {
        set {
            guard let newValue = newValue else { return }
            placeholder = NSLocalizedString(newValue, comment: "")
        }
        get { return placeholder }
    }
}
