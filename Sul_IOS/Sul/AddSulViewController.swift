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
    
    
    // 받을 정보
    struct sul {
        var name:String
        var price:Int
    }
    
    var curSul:sul? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 여기다 하는게 맞나?
        if ((curSul) != nil) {
            vcTitle.title = "술 수정"
            sulSave.title = "수정"
        }else{
            vcTitle.title = "술 추가"
            sulSave.title = "추가"
        }
        
    }
    
    
    @IBAction func sulSaveClick(_ sender: Any) {
        // SAVE SUL INFO
        var sulList = UserDefaults.standard.value(forKey: "sulList") as! [Any]  // LOAD
        sulList.append(curSul)
        UserDefaults.standard.set(sulList, forKey:"sulList")  // SAVE
        
    }

}
