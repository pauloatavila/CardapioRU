//
//  MenuTableViewCell.swift
//  RU
//
//  Created by Paulo Atavila on 07/10/2018.
//  Copyright © 2018 Paulo Atavila. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var opcaoImagem: UIImageView!
    @IBOutlet weak var opcaoLabel: UILabel!
    @IBOutlet weak var viewSeparar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
