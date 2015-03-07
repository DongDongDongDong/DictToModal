//
//  Model.swift
//  DictToModel_Swift
//
//  Created by apple on 15/3/7.
//  Copyright (c) 2015年 Ai. All rights reserved.
//

import UIKit

class Model: NSObject ,DictToModelProtocol{
    var str1 : String?
    var str2 : NSString?
    var b : Bool = true
    var i : UInt?
    var f : Float?
    var d : Double?
    var num : NSNumber?
    var info : Info?
    var other :[Info]?
    var others : NSArray?
    
    // 协议方法，返回属性对应的真实类型

    static func classMapping() -> [String : String]? {
        return["info":"Info","other":"Info","others":"Info"]
    }
}
class SubModel: Model {
    var boy:String?
}

class Info {
    var name : String?
}