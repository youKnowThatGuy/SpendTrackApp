//
//  ServerResponse.swift
//  SpendTrack
//
//  Created by Клим on 03.03.2021.
//

import Foundation

struct ServerResponse<Object: Decodable>: Decodable{
    var shopping_results: [Object]
}
