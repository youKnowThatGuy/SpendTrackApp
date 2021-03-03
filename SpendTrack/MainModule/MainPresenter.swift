//
//  MainPresenter.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import Foundation
import Charts

class MainPresenter{
    private var entries = [ChartDataEntry]()
    
    func getChartData() -> ChartData{
        for x in 0..<10{
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: set)
        return data
    }
    
    func prepareCategorySegue(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier{
        case "categorySegue":
            guard let vc = segue.destination as? CategoryViewController,
                  let text = sender as? String
            else {fatalError("invalid data passed")}
            vc.text = text
        default:
            break
        }
        
        
    }
    
    
    
}
