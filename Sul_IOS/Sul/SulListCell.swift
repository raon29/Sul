//
//  TableViewCell.swift
//  Sul
//
//  Created by misong lee on 13/12/2020.
//  Copyright © 2020 misong lee. All rights reserved.
//

import UIKit

class SullListCell: UITableViewCell {

    @IBOutlet weak var sulImg: UIImageView!
    @IBOutlet weak var sulName: UILabel!
    @IBOutlet weak var sulPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
