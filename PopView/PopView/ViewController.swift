//
//  ViewController.swift
//  PopView
//
//  Created by weiwei.li on 2020/7/10.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.cornerRadii = CornerRadiiMake(10, 10, 10, 10)
        imageView.cornerRadii = CornerRadiiMake(10, 0, 0, 10)
    }
    
    @IBAction func action(_ sender: Any) {
        let testV = ActivityTestView()
        testV.dismissCompleted = {
            print("123123123")
        }
        testV.show(in: view)
    }
    
}

