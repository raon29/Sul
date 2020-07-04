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
    
    @IBOutlet weak var change: UILabel!
    
    
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
        
        struct sul {
            var name:String
            var price:Int
        }

        // 소주 5000원, 맥주 4000원
        var soju = sul(name:"soju", price:5000)
        var beer = sul(name:"beer", price:4000)
        var somacList:[sul] = [soju, beer]
        // 가격별로 sorting
        somacList = somacList.sorted(by: { $0.price > $1.price } )
        
        if( money >= somacList[somacList.count - 1].price ){
            var calMoney:Int = money

            for sul in somacList {
                // 술 종류 가격별로
                if(calMoney >= sul.price){
                    var bottle:Int = calMoney/sul.price
                    
                    calMoney = calMoney%sul.price
                }
            }
            
            // 남은 돈 출력
            change.text = String(calMoney) + "원 남았습니다."
            
        }
        else{
            change.text = "아직은 때가 아니다."
        }
    }
}

