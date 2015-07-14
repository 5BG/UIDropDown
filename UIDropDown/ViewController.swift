//
//  ViewController.swift
//  UIDropDown
//
//  Created by 5BG on 2015/7/14.
//  Copyright © 2015年 Sunny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var txtLanguage: UITextField!
    let languageOptions = ["English", "Chinese", "Korean", "French", "Spanish", "Japanese"]
    var dropdown: UIDropDown?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dropdown = UIDropDown(textField: txtLanguage, dropdownlist: languageOptions)
        print("update")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

