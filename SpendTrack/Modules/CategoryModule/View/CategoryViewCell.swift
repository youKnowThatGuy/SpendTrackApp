//
//  CategoryViewCell.swift
//  SpendTrack
//
//  Created by Клим on 02.05.2021.
//

import UIKit

class CategoryViewCell: UITableViewCell {
    
    static let identifier = "CategoryCell"

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        //self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
        innerView.layer.cornerRadius = 20
        innerView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
