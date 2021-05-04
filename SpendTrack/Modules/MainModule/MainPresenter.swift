//
//  MainPresenter.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import Foundation
import Charts

protocol MainPresenterProtocol{
    init(view: MainViewProtocol)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func getChartData() -> ChartData
    func getCachedData()
}

class MainPresenter: MainPresenterProtocol{
    
    weak var view: MainViewProtocol?
    
    var entries = [ChartDataEntry]()
    var raw_data = [CachedPurchase]()
    var colors = [UIColor]()
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getCachedData() {
        CachingService.shared.getPurchases { (data) in
            self.raw_data = data!
            self.view?.updateUI()
        }
    }
    
    func getChartData() -> ChartData{
        sortData()
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        colors = set.colors
        let data = PieChartData(dataSet: set)
        return data
    }
    
    func sortData(){
        var category_mas = [String]()
        var count_mas = [Double]()
        for single in raw_data{
            if !category_mas.contains(single.category){
                category_mas.append(single.category)
                count_mas.append(single.price)
            }
            else {
                let index = category_mas.firstIndex(of: single.category)!
                count_mas[index] += single.price
            }
        }
        entries = []
        for i in 0..<category_mas.count{
            entries.append(PieChartDataEntry(value: count_mas[i], label: category_mas[i]))
        }
        
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier{
        case "categorySegue":
            guard let vc = segue.destination as? CategoryViewController
            else {fatalError("invalid data passed")}
            vc.presenter = CategoryPresenter(view: vc, data: raw_data)
            
        case "purchasesSegue":
            guard let vc = segue.destination as? PurchasedViewController
            else {fatalError("invalid data passed")}
            vc.presenter = PurchasedPresenter(view: vc, data: raw_data)
        default:
            break
        }
        
        
    }
    
    
    
}
