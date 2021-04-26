//
//  SearchPresenter.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import UIKit

protocol SearchPresenterProtocol{
    init(view: SearchViewProtocol)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func saveRecentSearch(query: String)
    func loadRecentSearches()
    func loadItems(query: String)
    func getDataCount() -> Int
    func getIndexData(index: Int) -> SingleResult
    func prepareCell(cell: SearchViewCell, index: Int)
}

class SearchPresenter: SearchPresenterProtocol{
    weak var view: SearchViewProtocol?
    var searchedData = [SingleResult]()
    
    required init(view: SearchViewProtocol) {
        self.view = view
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showDetailPurchase":
            guard let vc = segue.destination as? DetailViewController,
                  let data = sender as? SingleResult
            else {fatalError("Invalid data passed")}
            vc.presenter = DetailPresenter(view: vc, data: data)
        default:
            break
        }

    }
    
    func saveRecentSearch(query: String){
       CachingService.shared.cacheSearches(query)
   }
    
    func loadRecentSearches() {
        CachingService.shared.getSearches { (searches) in
            self.view!.resultsTableViewController.suggestedSearches = searches.components(separatedBy: ", ")
        }
    }
    
    func loadItems(query: String) {
        searchedData.removeAll()
        NetworkService.shared.fetchSearchData(query: query) { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(searchInfo):
                self.searchedData = searchInfo
                if (searchInfo.count != 0) {
                self.view!.updateUI()
                }
            }
        }
    }
    
    func getDataCount() -> Int {
        searchedData.count
    }
    
    func getIndexData(index: Int) -> SingleResult {
        return searchedData[index]
    }
    
    func prepareCell(cell: SearchViewCell, index: Int) {
        let currData = searchedData[index]
        cell.nameLabel.text = currData.title
        cell.priceLabel.text = currData.price_raw
        cell.merchantLabel.text = "Продавец: \(currData.merchant)"
        
        NetworkService.shared.loadImage(from: URL(string: currData.image)) { (image) in
            if image != nil{
            cell.itemView.image = image
            }
            else{
                cell.itemView.image = UIImage(named: "noImage")
            }
        }
    }
    
}
