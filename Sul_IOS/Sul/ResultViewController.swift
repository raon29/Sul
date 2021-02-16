//
//  ResultViewController.swift
//  Sul
//
//  Created by misong lee on 05/12/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit

class ResultViewController: UITableViewController {
    
    // 입력받은 가격
    var haveMoney:Int = 0

    var list = [SulVO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ResultListCell
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(row.name + ".jpg")
        if (row.img){
            do { cell.ResultImg.image = try UIImage( data: Data(contentsOf: url) ) }
            catch{
                // 이미지 로드 실패 Alert
                let alert = UIAlertController(title: "이미지 가져오기 실패", message: "이미지를 가져오는데 실패하였습니다.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: false, completion: nil)
            }
        }else{
            // 기본이미지로 Setting
            cell.ResultImg.image = UIImage(named: "sul")
        }
        if (row.price != 0) {
            cell.ResultBottle.text = String( haveMoney / row.price )
        }
        return cell
    }
}
