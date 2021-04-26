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
}

class DetailPresenter: DetailPresenterProtocol{
    weak var view: DetailViewProtocol?
    var data: SingleResult!
    
    required init(view: DetailViewProtocol, data: SingleResult) {
        self.view = view
        self.data = data
        loadData()
    }
    func loadData(){
        NetworkService.shared.loadImage(from: URL(string: data.image)) { [self] (image) in
            if image == nil{
                view?.updateUI(data: data, image: UIImage(named: "noImage")!)
            }
            else{
                view?.updateUI(data: data, image: image!)
            }
        }
    }
    
    
}
