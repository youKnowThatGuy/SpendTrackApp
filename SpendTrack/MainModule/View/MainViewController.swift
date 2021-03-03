//
//  MainViewController.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//
import Charts
import UIKit

class MainViewController: UIViewController, ChartViewDelegate {
    
    var pieChart = PieChartView()
    var presenter: MainPresenter!
    let tapReact = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter()
        pieChart.delegate = self
        preparePieChart()
        tapReact.addTarget(self, action: #selector(chartTapped) )
        
    }
    
    func preparePieChart(){
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width / 1.4, height: self.view.frame.size.width / 1.4)
        view.addSubview(pieChart)
        setupImageScrollViewLayout()
        //pieChart.centerText = "Hello world"
        
        pieChart.data = presenter.getChartData()
        
        pieChart.addGestureRecognizer(tapReact)
        pieChart.rotationEnabled = false
        pieChart.legend.enabled = false
        
    }
    
    private func setupImageScrollViewLayout() {
        let margins = view.layoutMarginsGuide
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.topAnchor.constraint(equalTo: margins.topAnchor, constant: 43).isActive = true
        pieChart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -440).isActive = true
        
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        pieChart.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true //right
        pieChart.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true //left
    }
    
    @objc func chartTapped() {
        performSegue(withIdentifier: "categorySegue", sender: "Hello world!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepareCategorySegue(for: segue, sender: sender)
    }
    

    

}
