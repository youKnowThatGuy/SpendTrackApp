//
//  PurchasedPresenter.swift
//  SpendTrack
//
//  Created by Клим on 03.05.2021.
//

import Foundation
import Kingfisher

protocol PurchasedPresenterProtocol{
    init(view: PurchasedViewProtocol, data: [CachedPurchase])
    func getNumberOfSections() -> Int
    func getPurchasesSum() -> Double
    func getNumberOfRowsInSection(for section: Int) -> Int
    func prepareCell(cell: PurchasedViewCell, index: IndexPath)
    func getSectionTitle(for section: Int) -> String
    func sortSegmentData(choice: Int)
}

class PurchasedPresenter: PurchasedPresenterProtocol{
    weak var view: PurchasedViewProtocol?
    var raw_data = [CachedPurchase]()
    var dictionary: [String: [CachedPurchase]] = [:]
    var segmentDictionary: [String: [CachedPurchase]] = [:]
    var segmentSelected = false
    var sumChoice = 0
    
    required init(view: PurchasedViewProtocol, data: [CachedPurchase]) {
        self.view = view
        self.raw_data = data
        sortData()
    }
    
    func getPurchasesSum() -> Double{
        var segmentData = raw_data
        if sumChoice != 0{
            for i in 0..<raw_data.count{
                let endDate = Int(Date().timeIntervalSince1970)
                let startDate = endDate - sumChoice
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                let string = raw_data[i].purchase_date
                let currDate = Int(formatter.date(from: string)!.timeIntervalSince1970)
                if currDate < startDate || currDate > endDate {
                    segmentData.remove(at: i)
                }
            }
        }
        
        var category_mas = [String]()
        var count_mas = [Double]()
        for single in segmentData{
            if !category_mas.contains(single.category){
                category_mas.append(single.category)
                count_mas.append(single.price)
            }
            else {
                let index = category_mas.firstIndex(of: single.category)!
                count_mas[index] += single.price
            }
        }
        return count_mas.reduce(0, +)
    }
    
    func sortData(){
        for purchase in raw_data{
            if !dictionary.keys.contains(purchase.purchase_date){
                dictionary[purchase.purchase_date] = [purchase]
            }
            else{
                var mas = dictionary[purchase.purchase_date]
                mas?.append(purchase)
                dictionary[purchase.purchase_date] = mas
            }
        }
    }
    
    func sortSegmentData(choice: Int){
        if choice == 0{
            segmentSelected = false
            sumChoice = 0
            view?.updateUI()
        }
        else{
            segmentSelected = true
            segmentDictionary = dictionary
            let endDate = Int(Date().timeIntervalSince1970)
            let startDate = endDate - choice
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            for key in dictionary.keys{
                let currDate = Int(formatter.date(from: key)!.timeIntervalSince1970)
                if currDate < startDate || currDate > endDate {
                    segmentDictionary.removeValue(forKey: key)
                }
            }
            sumChoice = choice
            view?.updateUI()
            
        }
    }
    
    func prepareCell(cell: PurchasedViewCell, index: IndexPath) {
        var dict = dictionary
        if segmentSelected == true{
            dict = segmentDictionary
        }
        
        let secCount = dict.keys.count - 1 - index.section
        let key = Array(dict.keys)[secCount]
        let dataC = dict[key]!.count
        let data = dict[key]![dataC - 1 - index.row]
        
        cell.categoryLabel.text = data.category
        cell.merchantLabel.text = data.merchant
        let resource = ImageResource(downloadURL: URL(string: data.image_url)!)
        cell.purchasedImageView.kf.setImage(with: resource)
        cell.sumLabel.text = data.price_raw
        cell.titleLabel.text = data.title
    }
    
    func getNumberOfSections() -> Int{
        if segmentSelected == true{
            return segmentDictionary.keys.count
        }
        else{
            return dictionary.keys.count
        }
    }
    
    func getSectionTitle(for section: Int) -> String {
        if segmentSelected == true{
            let count = segmentDictionary.keys.count - 1 - section
            return Array(segmentDictionary.keys)[count]
        }
        else{
            let count = dictionary.keys.count - 1 - section
            return Array(dictionary.keys)[count]
        }
    }
    
    func getNumberOfRowsInSection(for section: Int) -> Int{
        if segmentSelected == true{
            let count = segmentDictionary.keys.count - 1 - section
            let key = Array(segmentDictionary.keys)[count]
            return segmentDictionary[key]!.count
        }
        else{
            let count = dictionary.keys.count - 1 - section
            let key = Array(dictionary.keys)[count]
            return dictionary[key]!.count
        }
    }
}
