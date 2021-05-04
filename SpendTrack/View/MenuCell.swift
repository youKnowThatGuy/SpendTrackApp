//
//  MenuCell.swift
//  SpendTrack
//
//  Created by Клим on 04.05.2021.
//

import UIKit
import DropDown

class MenuCell: DropDownCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
