//
//  AddSulViewController.swift
//  Sul
//
//  Created by misong lee on 10/12/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit

class AddSulViewController: UIViewController {

    @IBOutlet weak var vcTitle: UINavigationItem!
    @IBOutlet weak var sulSave: UIBarButtonItem!
    
    @IBOutlet weak var sulIMG: UIImageView!
    @IBOutlet weak var sulName: UITextField!
    @IBOutlet weak var sulPrice: UITextField!
    
    // 받을 정보
    
    var curSul:SulVO? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((curSul) != nil) {
            vcTitle.title = "술 수정"
            sulSave.title = "수정"
            
            // TODO :: 이미지 추가
            sulName.text = curSul?.name
            sulPrice.text = String(curSul?.price as! Int)
            
        }else{
            vcTitle.title = "술 추가"
            sulSave.title = "추가"
        }
        
    }
    
    
    @IBAction func sulSaveClick(_ sender: Any) {
        let myDB = DBHelper.shared;
        
        // 값만 수정
        if(curSul?.name == sulName.text){
            var DataUpdate:String = "update sulListTB set price = \"" + sulPrice.text! + "\" where name = \"" + curSul!.name + "\";"
            if( myDB.commitQuery(query: DataUpdate) ){
                self.navigationController?.popViewController(animated: true)
            }else{
                //TODO:: 수정에 실패했어용 :< alert
                
            }
        }
        
        // Name 중복 Check
        var nameSul = "select * from sulListTB where name = \"" + sulName!.text! + "\";"
        var result:[SulVO] = myDB.readSULData(query: nameSul) as! [SulVO]
        if (result.count < 1) {
            // SAVE SUL INFO
            var query:String;
            if(sulSave.title == "수정"){
                query = "update sulListTB set name = \"" + sulName.text! + "\", price = \"" + sulPrice.text! + "\" where name = \"" + curSul!.name + "\";"
            } else{
                query = "insert into sulListTB(name, price) values(\"" + self.sulName.text! + "\",\"" + self.sulPrice.text! + "\");"
                
            }
            if ( myDB.commitQuery(query: query) ){
                // sulList 화면으로 이동
                self.navigationController?.popViewController(animated: true)
            }else{
                // TODO :: sulSave.title (수정/추가) 실패했습니다.
                
            }
        }else{
            // TODO :: alert
            // 이미 존재하는 이름의 술입니다.
            
        }
        
    }

}
