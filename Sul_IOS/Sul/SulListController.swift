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
    
    @IBAction func moveAddSul(_ sender: Any) {
        // TODO SUL 편집화면으로 이동
        guard let avc = self.storyboard?.instantiateViewController(identifier: "AddSulVC") as? AddSulViewController else {return}
        self.navigationController?.pushViewController(avc, animated: true)
    }
    
}
