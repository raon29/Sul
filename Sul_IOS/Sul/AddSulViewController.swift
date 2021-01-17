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
    
    let picker = UIImagePickerController()
    
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
        
        picker.delegate = self
        
        //Img Action 추가
        let tgr = UITapGestureRecognizer(target: self, action: #selector(ImagePick))
        sulIMG.isUserInteractionEnabled = true
        sulIMG.addGestureRecognizer(tgr)
        
        
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
    @objc func ImagePick() {
        //ImpagePicker alert 구현
        let alert = UIAlertController(title: "술 사진을 골라주세요", message: nil, preferredStyle: .actionSheet)
        let album = UIAlertAction(title: "사진앨범", style: .default){
            (action) in self.openAlbum()
        }
        let camera = UIAlertAction(title: "카메라", style: .default){
            (action) in self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    func openAlbum() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
}

extension AddSulViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
}
