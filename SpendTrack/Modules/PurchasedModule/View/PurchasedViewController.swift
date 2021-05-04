//
//  PurchasedViewController.swift
//  SpendTrack
//
//  Created by Клим on 03.05.2021.
//

import UIKit
import DropDown

protocol PurchasedViewProtocol: UIViewController{
    func updateUI()
}

class PurchasedViewController: UIViewController {
    var presenter: PurchasedPresenterProtocol!
    var currentTableAnimation: TableAnimation = .moveUpWithFade(rowHeight: 72.0, duration: 0.85, delay: 0.03)
    var animationStartDate = Date()

    @IBOutlet weak var purchasedTableView: UITableView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var menuButtonShell: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purchasedTableView.delegate = self
        purchasedTableView.dataSource = self
        purchasedTableView.sectionHeaderHeight = 40
        setupCountingLabelAnimation()
        setupDropMenu(itemTitle: "Все время ᐯ")
        prepareBackButton()
    }
    
    func setupCountingLabelAnimation(){
        let displayLink = CADisplayLink(target: self, selector: #selector(handleCountingLabel))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc func handleCountingLabel(){
        let endValue = presenter.getPurchasesSum()
        let startValue = endValue / 2
        let animationDuration = 2.5
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration{
            var text = "\(Int(endValue))"
            text = Separator.shared.prepareSumString(string: text)
            self.countLabel.text = "\(text)"
        }
        else{
            let percentage = elapsedTime / animationDuration
            var value = startValue + percentage * (endValue - startValue)
            value = Double(round(10000*value)/10000)
            self.countLabel.text = "\(value) ₽"
        }
    }
    
    func setupDropMenu(itemTitle: String){
        menuButtonShell.setTitle(itemTitle, for: .normal)
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
    
}

extension PurchasedViewController: PurchasedViewProtocol{
    func updateUI() {
        purchasedTableView.reloadData()
        animationStartDate = Date()
        setupCountingLabelAnimation()
    }
}

extension PurchasedViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRowsInSection(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchasedViewCell.identifier, for: indexPath) as! PurchasedViewCell
        presenter.prepareCell(cell: cell, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect.zero)
        vw.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 70, height: 20))
        label.text = presenter.getSectionTitle(for: section)
        label.font = UIFont(name: "DIN Condensed Bold", size: 20.0)
        vw.addSubview(label)

        return vw
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    
}
