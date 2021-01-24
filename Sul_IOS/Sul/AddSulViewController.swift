//
//  AddSulViewController.swift
//  Sul
//
//  Created by misong lee on 10/12/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit

class AddSulViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var vcTitle: UINavigationItem!
    @IBOutlet weak var sulSave: UIBarButtonItem!
    
    @IBOutlet weak var sulIMG: UIImageView!
    @IBOutlet weak var sulName: UITextField!
    @IBOutlet weak var sulPrice: UITextField!
    
    let picker = UIImagePickerController()
    
    // 받을 정보
    var curSul:SulVO? = nil;
    var imgModify:Bool = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sulName.delegate = self
        sulPrice.delegate = self
        
        if ((curSul) != nil) {
            vcTitle.title = "술 수정"
            sulSave.title = "수정"
            
            sulName.text = curSul?.name
            sulPrice.text = String(curSul?.price as! Int)
            if (curSul!.img) {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let url = documents.appendingPathComponent(curSul!.name + ".jpg")
                do { sulIMG.image = try UIImage( data: Data(contentsOf: url) ) }
                catch {
                    // 이미지 로드 실패 Alert
                    let alert = UIAlertController(title: "이미지 가져오기 실패", message: "이미지를 가져오는데 실패하였습니다.", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    present(alert, animated: false, completion: nil)
                }
            } else {
                //TODO 추가 이미지 setting (+)
            }
            
            
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
                // img 처리
                if(imgModify){
                    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    do {
                        try FileManager.default.removeItem(atPath: documents.path + "/" + sulName.text! + ".jpg")
                    } catch {
                        //TODO :: alret
                    }
                    if(sulIMG.image != nil) {
                        print("이미지 수정 ㄲ ")
                        self.saveImg()
                    }
                }
            }else{
                // 수정에 실패했어용 :< alert
                let alert = UIAlertController(title: "이미지 수정 실패", message: "이미지를 수정하는대 실패하였습니다.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: false, completion: nil)
            }

        }
        
        // Name 중복 Check
        var nameSul = "select * from sulListTB where name = \"" + sulName!.text! + "\";"
        var result:[SulVO] = myDB.readSULData(query: nameSul) as! [SulVO]
        if (result.count < 1) {
            // SAVE SUL INFO
            var query:String;
            if(sulSave.title == "수정"){
                query = "update sulListTB set name = \"\(sulName.text!)\", price = \"\( sulPrice.text!)\", img = \(curSul!.img == true ? 1:0) where name = \"\( curSul!.name)\";"
            } else{
                query = "insert into sulListTB(name, price, img) values(\"\(self.sulName.text!)\",\"\(self.sulPrice.text!)\",\( self.sulIMG.image != nil ? 1:0));"
            }
            if ( myDB.commitQuery(query: query) ){
                if(sulIMG.image != nil) {
                    print("이미지 저장 ㄲ ")
                    self.saveImg()
                }
                // sulList 화면으로 이동
                self.navigationController?.popViewController(animated: true)
            }else{
                //  sulSave.title (수정/추가) 실패했습니다.
                let alert = UIAlertController(title: "술 저장 실패", message: "술 추가 및 수정에 실패했습니다.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: false, completion: nil)
            }
        }else{
            // 이미 존재하는 이름의 술입니다.
            let alert = UIAlertController(title: "술 저장 실패", message: "이미 존재하는 이름의 술입니다.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: false, completion: nil)
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
        let delete = UIAlertAction(title: "삭제", style: .destructive){
            //TODO 추가 이미지 setting (+)
            (action) in print("")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    func openAlbum() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else{
            // 카메라 못연다는 alert
            let alert = UIAlertController(title: "카메라 열기 실패", message: "카메라 열기에 실패했습니다.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: false, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            sulIMG.image = img
            imgModify = true
            curSul?.img = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveImg(){
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        // Convert to Data
        if let data = sulIMG.image!.jpegData(compressionQuality: 0.5) {
            do {
                try data.write(to: documents.appendingPathComponent(self.sulName.text! + ".jpg"))
            } catch {
                // 이미지 저장실패 alert
                let alert = UIAlertController(title: "이미지 저장 실패", message: "이미지를 저장하는대 실패하였습니다.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: false, completion: nil)
            }
        }
    }
    // 터치시 keyboard 닫기 설정
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
}

extension AddSulViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
}
