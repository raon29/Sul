//
//  ViewController.swift
//  Sul
//
//  Created by misong lee on 08/06/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var inputMoney: UITextField!

    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputMoney.delegate = self
        
        
        
        
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
        if textField.text == "" {
            textField.text = "0"
        }
        // 계산 함수 호출
        self.caculSul(moneystr: textField.text!)
    }
    func caculSul(moneystr:String){
        let money:Int! = Int(moneystr)
        if(money > 4000){
            let bottle_count:Int = money/4000
            for i in 1...bottle_count {
                // 병수만큼 for문 돌면서 아이템 추가
                print(i)
            }
        }
    }
}

