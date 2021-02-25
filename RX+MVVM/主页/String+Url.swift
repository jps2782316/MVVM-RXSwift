//
//  String+Url.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/28.
//  Copyright © 2018年 jps. All rights reserved.
//

import Foundation

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

