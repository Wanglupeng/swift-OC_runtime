//
//  UIButton_Extension.swift
//  Swift_Runtime
//
//  Created by sim on 2018/2/3.
//  Copyright © 2018年 wanglupeng. All rights reserved.
//

import Foundation
import UIKit

var blockKey = "BLOCKKEY"
typealias clickBlock = ()->Void
extension UIButton{
    func SwiftaddtouchHandle(handle:clickBlock)  {
        objc_setAssociatedObject(self, &blockKey, handle, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(clicked), for: UIControlEvents.touchUpInside)
    }
    
    @objc func clicked()  {
        if let myblock:clickBlock = objc_getAssociatedObject(self, &blockKey) as? clickBlock{
            myblock()
        }
    }
}
