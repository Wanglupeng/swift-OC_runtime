//
//  ViewController.swift
//  Swift_Runtime
//
//  Created by sim on 2018/2/2.
//  Copyright © 2018年 wanglupeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var cat = { () -> Cat in
        let c = Cat()
        c.name = "sam"
        c.sex = "man"
        return c
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        @property (nonatomic,strong) UIView *contentView;
        
        // Person 实例Runtime中结构体相关数据
        personRuntime()
        personUnselectorMethod()
        createSwiftButton()
        createOCButton()
        swillMethod()
        modelSerializeWithDic()
        
    }
    
    
    //MARK: - Swift添加Button
    func createSwiftButton()  {
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 30)
        btn.backgroundColor = UIColor.red
        btn.setTitle("SwiftButton", for: UIControlState.normal)
        btn.SwiftaddtouchHandle {
            print("SwiftButton点击了")
        }
        self.view.addSubview(btn)
    }
  
    func createOCButton()  {
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = CGRect.init(x: 100, y: 200, width: 100, height: 30)
        btn.backgroundColor = UIColor.red
        btn.setTitle("OCbutton", for: UIControlState.normal)
        btn.addOChandle {
            print("OCbutton点击了")
        }
        self.view.addSubview(btn)

    }
    
    //MARK: -字典转模型
    func modelSerializeWithDic()  {
        let dic = ["name":"sam","sex":"man"]
        let c =  Cat.model(withDict: dic)
        print(c?.name)
        
    }
    
    //MARK: -Person 实例Runtime中结构体相关数据
    func personRuntime()  {
        cat.getMethodList()
        cat.getpropertyList()
        cat.getivarLis()
        cat.getprotocolList()
        cat.getclassName()
        cat.getSuperClass()
    }
    
    func swillMethod()  {
        Cat.swizzlingMehod()
        cat.eat()
        cat.run()
        
    }
    
    // person 未实现selector方法
    func personUnselectorMethod()  {
        cat.perfonromSelectorMethod()
    }
  

   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}

