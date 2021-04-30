//
//  CachedPurchase.swift
//  SpendTrack
//
//  Created by Клим on 27.04.2021.
//

import Foundation

struct CachedPurchase: Codable{
    var title: String
    var price: Double
    var price_raw: String
    var merchant: String
    var image_url: String
    var link: String
    var category: String
    var purchase_date: String
    
}
