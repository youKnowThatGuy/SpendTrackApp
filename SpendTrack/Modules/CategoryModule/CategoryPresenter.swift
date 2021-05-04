//
//  CategoryPresenter.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import Foundation
import Charts

protocol CategoryPresenterProtocol {
    init(view: CategoryViewProtocol, data: [CachedPurchase])
    func getChartData() -> ChartData
    func dataCount() -> Int
    func prepareCell(cell: CategoryViewCell, index: Int)
    func sortSegmentData(choice: Int)
}

class CategoryPresenter: CategoryPresenterProtocol{
    weak var view: CategoryViewProtocol?
    var raw_data = [CachedPurchase]()
    var segmentData = [CachedPurchase]()
    var entries = [ChartDataEntry]()
    var category_mas = [String]()
    var count_mas = [Double]()
    var colors = [UIColor]()
    
    required init(view: CategoryViewProtocol, data: [CachedPurchase]) {
        self.view = view
        self.raw_data = data
        self.sortData(choice: 0)
    }
    
    func getChartData() -> ChartData{
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        colors = set.colors
        let data = PieChartData(dataSet: set)
        return data
    }
    
    func sortData(choice: Int){
        segmentData = raw_data
        category_mas.removeAll()
        count_mas.removeAll()
        if choice != 0{
            for i in 0..<raw_data.count{
                let endDate = Int(Date().timeIntervalSince1970)
                let startDate = endDate - choice
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                let string = raw_data[i].purchase_date
                let currDate = Int(formatter.date(from: string)!.timeIntervalSince1970)
                if currDate < startDate || currDate > endDate {
                    segmentData.remove(at: i)
                }
            }
        }
        
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
        entries = []
        let sum = count_mas.reduce(0, +)
        for i in 0..<category_mas.count{
            let value = (count_mas[i] / sum) * 100
            entries.append(PieChartDataEntry(value: value, label: "\(category_mas[i]) %"))
        }
    }
    
    func sortSegmentData(choice: Int){
        sortData(choice: choice)
        view?.updateUI()
    }
    
    func dataCount() -> Int {
        return category_mas.count
    }
    
    func prepareCell(cell: CategoryViewCell, index: Int) {
        cell.categoryNameLabel.text = category_mas[index]
        var text = "\(Int(count_mas[index]))"
        text = Separator.shared.prepareSumString(string: text)
        cell.sumLabel.text = text
        cell.innerView.backgroundColor = colors[index]
        
        if index == 2{
            cell.categoryNameLabel.textColor = .black
            cell.sumLabel.textColor = .black
        }
    }
    
}

