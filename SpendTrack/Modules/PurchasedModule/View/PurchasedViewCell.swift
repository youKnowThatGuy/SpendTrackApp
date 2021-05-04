//
//  PurchasedViewCell.swift
//  SpendTrack
//
//  Created by Клим on 03.05.2021.
//

import UIKit

class PurchasedViewCell: UITableViewCell {
    static let identifier = "PurchasedCell"
    
    @IBOutlet weak var purchasedImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var merchantLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
