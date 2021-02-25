//
//  MainViewController.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/26.
//  Copyright © 2018年 jps. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func signupClick(_ sender: Any) {
        //设置了identifier的segue，就是一个手动的，只有调这句方法才能push
        self.performSegue(withIdentifier: "pushToSignupVC", sender: nil)
    }
    

}
