//
//  ViewController.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/23.
//  Copyright © 2018年 jps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dynamicAnimator = UIDynamicAnimator()
    var snap: UISnapBehavior?
    
    var imageView = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.red
        self.view.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        view.addGestureRecognizer(tap)
    }

    
    ///使用UI Dynamics给UIKit组件添加移动吸附行为
    @objc func tapped(sender: AnyObject) {
        //后去点击位置
        let tap = sender as! UITapGestureRecognizer
        let point = tap.location(in: self.view)
        
        //删除之前的吸附，添加一个新的
        if self.snap != nil {
            self.dynamicAnimator.removeBehavior(self.snap!)
        }
        
        self.snap = UISnapBehavior(item: self.imageView, snapTo: point)
        self.dynamicAnimator.addBehavior(self.snap!)
    }
    

}

