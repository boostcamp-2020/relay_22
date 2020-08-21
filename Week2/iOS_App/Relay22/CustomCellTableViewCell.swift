//
//  CustomCellTableViewCell.swift
//  Relay22
//
//  Created by A on 2020/08/21.
//  Copyright © 2020 gicho. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var nameLabel: UILabel!

    
    @IBOutlet weak var informationLabel: UILabel!
}
