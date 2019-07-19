//
//  RefeicaoTableViewCell.swift
//  RU
//
//  Created by Paulo Atavila on 04/10/2018.
//  Copyright © 2018 Paulo Atavila. All rights reserved.
//

import UIKit

class RefeicaoTableViewCell: UITableViewCell {

    @IBOutlet weak var itemRefeicao: UILabel!
    @IBOutlet weak var itemImagem: UIImageView!
    @IBOutlet weak var itemDescricao: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
