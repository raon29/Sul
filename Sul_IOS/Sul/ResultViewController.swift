//
//  ResultViewController.swift
//  Sul
//
//  Created by misong lee on 05/12/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    // 입력받은 가격
    var haveMoney:Int = 0
    
    @IBOutlet weak var ResultText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResultText.text = String(haveMoney)
        // Do any additional setup after loading the view.
    }
    
}
