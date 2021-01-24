//
//  SulChangeController.swift
//  Sul
//
//  Created by misong lee on 03/07/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import Foundation
import UIKit

class SulListController: UITableViewController{
    
    var list = [SulVO]()
    let myDB = DBHelper.shared;  //싱글톤 사용

    
    @IBAction func moveAddSul(_ sender: Any) {
        // TODO SUL 편집화면으로 이동
        guard let avc = self.storyboard?.instantiateViewController(identifier: "AddSulVC") as? AddSulViewController else {return}
        self.navigationController?.pushViewController(avc, animated: true)
    }
    
    override func viewDidLoad() {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
    func fetchData(){
        // TODO :: read 실패했을때.. 처리..
        var readSulQ = "select * from sulListTB;"
        self.list = myDB.readSULData(query: readSulQ) as! [SulVO]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! SullListCell
        cell.sulName.text = row.name
        cell.sulPrice.text = String(row.price)
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(row.name + ".jpg")
        if (row.img){
            do { cell.sulImg.image = try UIImage( data: Data(contentsOf: url) ) }
            catch{
                // 이미지 로드 실패 Alert
                let alert = UIAlertController(title: "이미지 가져오기 실패", message: "이미지를 가져오는데 실패하였습니다.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: false, completion: nil)
            }
        }else{
            // 기본이미지로 Setting
            cell.sulImg.image = UIImage(named: "sul")
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택시 수정 화면으로...
        guard let asvc = self.storyboard?.instantiateViewController(identifier: "AddSulVC") as? AddSulViewController else{return}
        asvc.curSul = self.list[indexPath.row]
        self.navigationController?.pushViewController(asvc, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            // 삭제 한번더 물어보는 alert창
            let alert = UIAlertController(title: "술 삭제", message: "술 목록에서 삭제하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){
                (action) in self.remove(indexPath: indexPath)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: false, completion: nil)
            
        }
    }
    func remove(indexPath: IndexPath){
        // DB에서 목록 삭제
        var deleteSulQ = "delete from sulListTB where name = \"" + self.list[indexPath.row].name + "\";"
        if( myDB.commitQuery(query: deleteSulQ) ){
            self.list.remove(at: indexPath.row)
            //TableView에서 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            do {
                try FileManager.default.removeItem(atPath: documents.path + "/" + self.list[indexPath.row].name + ".jpg")
            } catch {
                // 이미지 삭제 실패
            }
            
        }else{
            //  삭제에 실패했습니다 alert
            let alert = UIAlertController(title: "삭제 실패", message: "술을 삭제하는대 실패하였습니다.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: false, completion: nil)
        }
    }
}
