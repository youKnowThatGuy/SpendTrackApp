//
//  CategoryViewController.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import UIKit
import Charts
import DropDown

protocol CategoryViewProtocol: UIViewController{
    func updateUI()
}

class CategoryViewController: UIViewController, ChartViewDelegate{
    
    var presenter: CategoryPresenterProtocol!
    var pieChart = PieChartView()
    
    var currentTableAnimation: TableAnimation = .moveUpWithFade(rowHeight: 72.0, duration: 0.85, delay: 0.03)
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var menuButtonShell: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        pieChart.delegate = self
        prepareTableView()
        prepareBackButton()
        preparePieChart()
        setupDropMenu(itemTitle: "Все время ᐯ")
    }
    
    func preparePieChart(){
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width / 1.3, height: self.view.frame.size.width / 1.1)
        view.addSubview(pieChart)
        setupChartViewLayout()        
        pieChart.data = presenter.getChartData()
        pieChart.rotationEnabled = true
        pieChart.legend.enabled = false
    }
    
    func prepareTableView(){
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.separatorColor = .white
    }
    
    func setupDropMenu(itemTitle: String){
        menu.anchorView = menuButtonShell
        menu.selectionAction = { index, title in
            switch index {
            case 0:
                self.menuButtonShell.setTitle("Все время ᐯ", for: .normal)
                self.presenter.sortSegmentData(choice: 0)
            case 1:
                self.menuButtonShell.setTitle("Год       ᐯ", for: .normal)
                self.presenter.sortSegmentData(choice: 44064000)
            case 2:
                self.menuButtonShell.setTitle("Полгода   ᐯ", for: .normal)
                self.presenter.sortSegmentData(choice: 22032000)
            case 3:
                self.menuButtonShell.setTitle("Месяц     ᐯ", for: .normal)
                self.presenter.sortSegmentData(choice: 2419200)
            default:
                fatalError()
            }
            
        }
    }
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Все время", "Год", "Полгода", "Месяц"]
        menu.cellNib = UINib(nibName: "MenuCell", bundle: nil)
        menu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? MenuCell else{
                return
            }
            cell.imageView?.image = UIImage(named: "calendar")
        }
        return menu
    }()
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        menu.show()
    }
    
    func prepareBackButton(){
        let imgBackArrow = UIImage(named: "backButton")

        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow

        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "                                                               ", style: .plain, target: self, action: nil)
    }
    
    private func setupChartViewLayout() {
        let margins = view.layoutMarginsGuide
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.topAnchor.constraint(equalTo: margins.topAnchor, constant: 43).isActive = true
        pieChart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -415).isActive = true
        
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        pieChart.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true //right
        pieChart.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true //left
    }
    

}

extension CategoryViewController: CategoryViewProtocol{
    func updateUI() {
        preparePieChart()
        categoryTableView.reloadData()
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.dataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
        presenter.prepareCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}
