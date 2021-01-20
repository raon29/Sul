//
//  SulVO.swift
//  Sul
//
//  Created by misong lee on 13/12/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import Foundation

class SulVO {
    var name:String
    var price:Int
    var img:Bool
    init(name: String, price: Int){
        self.name = name
        self.price = price
        self.img = false
    }
    init (name: String, price: Int, img:Bool){
        self.name = name
        self.price = price
        self.img = img
    }
}

