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
        // TODO :: 여기서 이미지도 read 해주셈;;
        // TODO :: read 실패했을때.. 처리..
        var readSulQ = "select * from sulListTB;"
        self.list = myDB.readSULData(query: readSulQ) as! [SulVO]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO:: 이미지 추가~~
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! SullListCell
        cell.sulName.text = row.name
        cell.sulPrice.text = String(row.price)
        
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
            // TODO :: 삭제 한번더 물어보는 alert창
            // DB에서 목록 삭제
            var deleteSulQ = "delete from sulListTB where name = \"" + self.list[indexPath.row].name + "\";"
            if( myDB.commitQuery(query: deleteSulQ) ){
                self.list.remove(at: indexPath.row)
                //TableView에서 삭제
                tableView.deleteRows(at: [indexPath], with: .fade)
            }else{
                // TODO :: 삭제에 실패했습니다 alert
            }
        }
    }
    
}
