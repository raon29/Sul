//
//  ResultListCell.swift
//  Sul
//
//  Created by misong lee on 15/02/2021.
//  Copyright © 2021 misong lee. All rights reserved.
//

import UIKit

class ResultListCell: UITableViewCell {

    @IBOutlet weak var ResultBottle: UILabel!
    @IBOutlet weak var ResultImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
