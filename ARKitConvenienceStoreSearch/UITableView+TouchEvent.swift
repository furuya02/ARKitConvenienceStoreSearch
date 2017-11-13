//
//  UITableView+TouchEvent.swift
//  ARKitConvenienceStoreSearch
//
//  Created by SIN on 2017/11/13.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit

extension UITableView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

