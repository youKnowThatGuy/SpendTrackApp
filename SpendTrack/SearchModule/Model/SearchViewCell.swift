//
//  SearchViewCell.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import UIKit

class SearchViewCell: UITableViewCell {
    static let identifier = "ItemCell"
    
    @IBOutlet weak var itemView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
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
