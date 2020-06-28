//
//  ViewController.swift
//  Sul
//
//  Created by misong lee on 08/06/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var resultSul: UILabel!
    @IBOutlet weak var inputMoney: UITextField!

    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //input number pad로 설정
        inputMoney.keyboardType = .numberPad
        
        
        
        
    }
    
    // setting Button 눌렀을 때
    @IBAction func settingClick(_ sender: Any) {
        print("settnig click!")
    }
    // change Button 눌렀을 때
    @IBAction func changeClick(_ sender: Any) {
        print("change click!")
    }
    
    // 터치시 keyboard 닫기 설정
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print( "편집 종료" )
        print(textField)
    }
    
}

