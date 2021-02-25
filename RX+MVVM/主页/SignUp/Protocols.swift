//
//  Protocols.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/28.
//  Copyright © 2018年 jps. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

///根据验证结果显示不同的文字颜色
struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}


///验证结果
enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
    
    ///是否有效
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
    
    ///对于各种结果状态的文字描述
    var description: String {
        switch self {
        case let .ok(message):
            return message
            
        case .empty:
            return ""
            
        case .validating:
            return "validating..."
            
        case let .failed(message):
            return message
        }
    }
    
    ///各种结果状态的文字颜色
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.blue
        case .failed:
            return ValidationColors.errorColor
        }
    }

}





enum SignupState {
    case signedUp(signedUp: Bool)
}




///不写这句，label无法绑定ValidationResult
extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}






//alphanumerics 字母数字

