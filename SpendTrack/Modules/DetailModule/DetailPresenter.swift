//
//  DetailPresenter.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import Foundation
import UIKit

protocol DetailPresenterProtocol{
    init(view: DetailViewProtocol, data: SingleResult)
    var purchased: Bool {get}
    func addPurchase()
    func deletePurchase()
    func cachePurchase()
    func openMerchantSite()
    func getData()
    func prepareData(category: String)
}

class DetailPresenter: DetailPresenterProtocol{
    weak var view: DetailViewProtocol?
    var data: SingleResult!
    var purchased = false
    var purchasedItemData: CachedPurchase!
    var mas = [CachedPurchase]()
    
    required init(view: DetailViewProtocol, data: SingleResult) {
        self.view = view
        self.data = data
    }
    func getData(){
        /*
        NetworkService.shared.loadImage(from: URL(string: data.image)) { [self] (image) in
            if image == nil{
                view?.updateUI(data: data, image: UIImage(named: "noImage")!)
            }
            else{
                view?.updateUI(data: data, image: image!)
            }
        
        }
 */
        CachingService.shared.getPurchases { (result) in
            self.mas = result!
        }
        view?.updateUI(data: data)
    }
    
    func addPurchase() {
        purchased = true
    }
    func deletePurchase() {
        purchased = false
        view?.updateButton(price: data.price_raw)
    }

    func openMerchantSite() {
        view?.showWebPage(for: URL(string: data.link)!)
    }
    
    func cachePurchase() {
        if purchased == true {
            mas.append(self.purchasedItemData)
            CachingService.shared.cachePurchases(mas)
        }
    }
    
    func prepareData(category: String){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date_str = formatter.string(from: date)
        purchasedItemData = CachedPurchase(title: data.title, price: data.price, price_raw: data.price_raw, merchant: data.merchant, image_url: data.image, link: data.link, category: category, purchase_date: date_str)
    }
    
}
