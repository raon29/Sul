//
//  ViewController.swift
//  Sul
//
//  Created by misong lee on 08/06/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var inputMoney: UITextField!

    @IBOutlet weak var addSulBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var resultBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputMoney.delegate = self
        resultBtn.isHidden = true
        resultText.isHidden = true
        
        
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
        
        // sul list db에서 가져와서 읽기
        var readSulQ = "select * from sulListTB;"
        let myDB = DBHelper.shared;
        var sulList:[SulVO] = myDB.readSULData(query: readSulQ) as! [SulVO]
        
        if (sulList.count == 0){
            //TODO :: 등록하러가기 icon으로 변경
            resultBtn.setBackgroundImage(UIImage(named: "addsul"), for: .normal)
            resultBtn.addTarget(self, action: #selector(goAddSul), for: .touchUpInside)
            resultText.text = "등록된 술이 없어요 :(\n등록해주세용"
            
            resultBtn.isHidden = false
            resultText.isHidden = false
            
        }
        else{
            // 가격별로 sorting
            sulList = sulList.sorted(by: { $0.price < $1.price } )
            
            if( money >= sulList[0].price ){
                
                // TODO :: 가격보러가는 아이콘으로 변경
                resultBtn.setBackgroundImage(UIImage(named: "resultSul"), for: .normal)
                resultBtn.addTarget(self, action: #selector(goResultSul), for: .touchUpInside)

                // 멘트 숨기기 & btn 활성화
                resultText.isHidden = true
                resultBtn.isHidden = false
                
            }
            else{
                resultText.text = "아직은 때가 아니다."
                resultBtn.isHidden = true
                resultText.isHidden = false
            }
        }
    }
    @objc func goAddSul(){
        // sul 등록하는 페이지로..
        guard let asvc = self.storyboard?.instantiateViewController(identifier: "ListSulVC") else{return}
        self.navigationController?.pushViewController(asvc, animated: true)
    }
    @objc func goResultSul(_: Int) {
        // 계산된 sul 보여주는 페이지로 이동
        guard let rvc = self.storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController else {return}
        // 입력받은 가격 Data 전달
        rvc.haveMoney = Int(inputMoney.text ?? "0") ?? 0
        self.navigationController?.pushViewController(rvc, animated: true)
    }
}
