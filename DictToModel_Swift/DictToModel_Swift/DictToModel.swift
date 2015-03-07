//
//  DictToModel.swift
//  DictToModel_Swift
//
//  Created by apple on 15/3/7.
//  Copyright (c) 2015年 Ai. All rights reserved.
//

import UIKit

// 定义协议来获取属性自定义类型
// 在 Swift 中，如果希望让类动态调用协议方法，需要使用 @objc 的关键字
@objc protocol DictToModelProtocol{
    static func classMapping()->[String:String]?
}


class DictToModel: NSObject {
    

 /// 单例，全局访问接口
    static let shareManager = DictToModel()
    
    ///  将字典转化成模型
    ///
    ///  :param: dict 数据字典
    ///  :param: cls  模型类
    ///
    ///  :returns: 实例化的类对象
    func objectWithDictionary(dict:NSDictionary,cls:AnyClass)->AnyObject?{
        // 1.取出模型类的字典
        let DictIfo = fullModelInfo(cls)
            // 实例化对象
        var obj:AnyObject = cls.alloc()
        // 2.遍历模型字典，有哪些属性就设置哪些属性
        for(k,v) in DictIfo{
            // 取出字典内容
            if let value:AnyObject? = dict[k]{
                if v.isEmpty && !(value === NSNull()){
                    // 基本数据类型用KVC
                    obj.setValue(value, forKey: k)
                }else{
                    // 自定义类型(字典或数组)
                    let type = "\(value!.classForCoder)"
                    if type == "NSDictionary" {
                        // value是字典，将value的字典转换成info的对象
                        if let subObj:AnyObject? = objectWithDictionary(value as! NSDictionary, cls: NSClassFromString(v)) {
                         obj.setValue(subObj, forKey: k)
                        }
                    }else if type == "NSArray" {
                        // 数组同样要进行遍历
                        if let subObj: AnyObject? = objectWithArray(value as! NSArray, cls: NSClassFromString(v)) {
                            obj.setValue(subObj, forKey: k)
                        }
                    }
                        
                }
           }
        }
        return obj
        
    }
    
    ///  将数组转换成模型字典
    ///
    ///  :param: array 数组的描述
    ///  :param: cls 模型类
    ///
    ///  :returns: 模型数组
    func objectWithArray(array: NSArray, cls: AnyClass) -> [AnyObject]? {
        
        // 创建一个数组
        var result = [AnyObject]()
        
        // 1. 遍历数组
        // 可能存在什么类型？字典/数组
        for value in array {
            let type = "\(value.classForCoder)"
            
            if type == "NSDictionary" {
                if let subObj: AnyObject = objectWithDictionary(value as! NSDictionary, cls: cls) {
                    result.append(subObj)
                }
            } else if type == "NSArray" {
                if let subObj: AnyObject = objectWithArray(value as! NSArray, cls: cls) {
                    result.append(subObj)
                }
            }
        }
        
        return result
    }

    
    
    
    /// 缓存字典 【类名：模型字典】
    var modleCache = [String:[String:String]]()
    
    /// 循环遍历，子类父类所有属性
     func fullModelInfo(cls : AnyClass) -> [String:String]{
        // 判断信息是否被缓存
        if let cache = modleCache["\(cls)"]{
            println("\(cls)已经被缓存")
            return cache
        }
        
        // 模型字典
        var dictInfo = [String:String]()
        
        var currentClass: AnyClass = cls
        while let parent: AnyClass = currentClass.superclass(){
            // 取出，合并currentclass的模型字典
           dictInfo.merge(ModelInfo(currentClass))
            currentClass = parent
        }
        // 将模型写入缓存
        modleCache["\(cls)"] = dictInfo
        return dictInfo
    }
    
    
    
    /// 获取给定类的信息
     func ModelInfo(cls:AnyClass) -> [String : String]{
        
        
        // 判断信息是否被缓存
        if let cache = modleCache["\(cls)"]{
            println("\(cls)已经被缓存")
            return cache
        }
        
    var DictInfo = [String:String]()
        
    var count:UInt32 = 0
    let ivars = class_copyIvarList(cls, &count)
    println("一共\(count)个属性")
        
    // 判断类是否遵守了协议，如果遵守了，说明有自定义类型的对象
    var mapping:[String:String]?
    if cls.respondsToSelector("classMapping"){
        mapping = cls.classMapping()
        println("该类遵守了协议")
        println(mapping)
    
        // 依次遍历每个属性，获取其名字和类型
        for i in 0..<count{
            let ivar = ivars[Int(i)]
            // 获取的时C字符串
            let cname = ivar_getName(ivar)
            // 将其转换为swift的String
            let name = String.fromCString(cname)
            
            println("属性\(i + 1)是\(name!)类型是")
            
            // 获取其类型
            let type = mapping?[name!] ?? ""
                DictInfo[name!] = type
            }
        
      free(ivars)
        }
        println(DictInfo)
        
        // 将模型写入缓存
        modleCache["\(cls)"] = DictInfo
        
        return DictInfo
        
    }
    
    
}

// extension类似OC分类，给类和对象添加方法
extension Dictionary{
    ///  将给定的字典（可变的）合并到当前字典
    ///  mutating 表示函数操作的字典是可变类型的
    ///  泛型(随便一个类型)，封装一些函数或者方法，更加具有弹性
    ///  任何两个 [key: value] 类型匹配的字典，都可以进行合并操作
    mutating func merge<K,V>(dict:[K : V]){
//    mutating func merge(dict:[String:String]){
        for (k,v) in dict{
            // 字典的分类方法中，要使用update，要明确指定类型
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

