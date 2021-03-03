//
//  SingleResult.swift
//  SpendTrack
//
//  Created by Клим on 03.03.2021.
//

import Foundation

struct SingleResult: Decodable{
    var title: String
    var link: URL?
    var price: Int
    //var price_parsed: Price
    var merchant: String
    var image: URL?
}
