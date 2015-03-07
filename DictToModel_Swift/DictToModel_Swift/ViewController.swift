//
//  ViewController.swift
//  DictToModel_Swift
//
//  Created by apple on 15/3/7.
//  Copyright (c) 2015年 Ai. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        println(loadDict())
        
//      println(DictToModel.ModelInfo(Model.self))
//        DictToModel.ModelInfo(SubModel.self)
//        DictToModel.fullModelInfo(SubModel.self)
        let obj = DictToModel.shareManager
        obj.fullModelInfo(SubModel.self)
        obj.fullModelInfo(Model.self)
        obj.fullModelInfo(SubModel.self)
        
    }
    
    // 加载字典
    func loadDict() -> NSDictionary{
        var path = NSBundle.mainBundle().pathForResource("Model01.json", ofType: nil)
        var data = NSData(contentsOfFile: path!)
        return NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: nil) as! NSDictionary

        
    }



}

