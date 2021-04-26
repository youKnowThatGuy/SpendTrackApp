//
//  DetailViewController.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import UIKit

protocol DetailViewProtocol: UIViewController{
    func updateUI(data: SingleResult, image: UIImage)
}

class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var merchantLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var buttonShell: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonShell.layer.cornerRadius = 10
        buttonShell.layer.borderWidth = 1
        buttonShell.layer.borderColor = UIColor.black.cgColor
    }
}




extension DetailViewController: DetailViewProtocol{
    func updateUI(data: SingleResult, image: UIImage) {
        merchantLabel.text = data.merchant
        priceLabel.text = data.price_raw
        nameLabel.text = data.title
        buttonShell.setTitle("Купить за \(data.price_raw)", for: .normal)
        itemImageView.image = image
        if data.snippet != nil {
            descriptionLabel.text = data.snippet
        }
        else{
            descriptionLabel.text = "Нет описания..."
        }
    }
}
