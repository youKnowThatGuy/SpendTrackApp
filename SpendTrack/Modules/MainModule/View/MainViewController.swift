//
//  MainViewController.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//
import Charts
import UIKit

protocol MainViewProtocol: UIViewController{
    func updateUI()
}

class MainViewController: UIViewController, ChartViewDelegate {
    

    @IBOutlet weak var firstImageView: UIImageView!
    
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var purchasesButtonLabel: UILabel!
    @IBOutlet weak var viewedLabel: UILabel!
    
    var pieChart = PieChartView()
    var presenter: MainPresenterProtocol!
    let tapReact = UITapGestureRecognizer()
    let tapReactPurchases = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton(imageView: firstImageView, label: purchasesButtonLabel, picture: "money")
        customizeButton(imageView: secondImageView, label: viewedLabel, picture: "shopping")
        pieChart.delegate = self
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getCachedData()
    }
    
    func setupGestures(){
        tapReact.addTarget(self, action: #selector(chartTapped))
        tapReactPurchases.addTarget(self, action: #selector(purchasesTapped))
        firstImageView.addGestureRecognizer(tapReactPurchases)
    }
    
    
    func customizeButton(imageView: UIImageView, label: UILabel, picture: String){
        imageView.image = UIImage(named: picture)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
    }
    
    func preparePieChart(){
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width / 1.4, height: self.view.frame.size.width / 1.4)
        view.addSubview(pieChart)
        setupChartViewLayout()
        //pieChart.centerText = "Hello world"
        
        pieChart.data = presenter.getChartData()
        pieChart.addGestureRecognizer(tapReact)
        pieChart.rotationEnabled = true
        pieChart.legend.enabled = false
    }
    
    private func setupChartViewLayout() {
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
        performSegue(withIdentifier: "categorySegue", sender: nil)
    }
    
    @objc func purchasesTapped(){
        performSegue(withIdentifier: "purchasesSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }
}

extension MainViewController: MainViewProtocol{
    func updateUI() {
        preparePieChart()
    }
}
