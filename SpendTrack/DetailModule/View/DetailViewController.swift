//
//  DetailViewController.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import UIKit
import SafariServices
import SCLAlertView
import Kingfisher

protocol DetailViewProtocol: UIViewController{
    func updateUI(data: SingleResult)
    func showWebPage(for url: URL)
    func updateButton(price: String)
}

class DetailViewController: UIViewController, SFSafariViewControllerDelegate {
    var presenter: DetailPresenterProtocol!
    private var step = 0
    private var closingVC = false
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var merchantLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var buttonShell: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getData()
        buttonShell.layer.cornerRadius = 10
        buttonShell.layer.borderWidth = 1
        buttonShell.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if closingVC == true{
            presenter.cachePurchase()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if presenter.purchased == true{
            closingVC = true
        }
    }
    
    @IBAction func butonPressedPurchased(_ sender: Any) {
        if step == 0{
            buttonShell.setTitle("Перейти к продавцу", for: .normal)
            buttonShell.backgroundColor = .systemRed
            presenter.addPurchase()
            step += 1
            categoryAlert()
        }
        else if step == 1{
            buttonShell.setTitle("Приобретено", for: .normal)
            buttonShell.backgroundColor = .black
            step += 1
            presenter.openMerchantSite()
        }
        else if step == 2{
            deleteAlert()
        }
    }
    
    func deleteAlert(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Да") {
            self.presenter.deletePurchase()
            self.step = 0
            self.closingVC = false
            SCLAlertView().showTitle(
                "Товар отменён", // Title of view
                subTitle: "", timeout: nil,
                completeText: "Закрыть", // Optional button value, default: ""
                style: .success, // Styles - see below.
                colorStyle: 0x00FF00 ,
                colorTextButton: 0xFFFFFF
            )
        }
        alert.addButton("Нет") {}
        alert.showWarning("Вы уверены, что хотите удалить данный товар?", subTitle: "")
    }
    
    func categoryAlert(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let category =  alert.addTextField("Категория: ")
        alert.addButton("Готово") {
            if category.text == ""{
                let alertError = SCLAlertView(appearance: appearance)
                alertError.addButton("Хорошо"){
                    self.categoryAlert()
                }
                alertError.showError("Вы не ввели категорию товара", subTitle: "Попробуйте снова :)")
            }
            else{
                self.presenter.prepareData(category: category.text!)
            }
        }
        alert.showEdit("Введите категорию данного товара", subTitle: "")
    }
    
    private func safariViewControllerDidFinish(controller: SFSafariViewController)
   {
        controller.dismiss(animated: true, completion: nil)
   }
    
}


extension DetailViewController: DetailViewProtocol{
    func showWebPage(for url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func updateButton(price: String){
        buttonShell.setTitle("Купить за \(price)", for: .normal)
        buttonShell.backgroundColor = .systemBlue
    }
    
    func updateUI(data: SingleResult) {
        merchantLabel.text = data.merchant
        priceLabel.text = data.price_raw
        nameLabel.text = data.title
        buttonShell.setTitle("Купить за \(data.price_raw)", for: .normal)
        //itemImageView.image = image
        let resource = ImageResource(downloadURL: URL(string: data.image)!)
        itemImageView.kf.setImage(with: resource)
        if data.snippet != nil {
            descriptionLabel.text = data.snippet
        }
        else{
            descriptionLabel.text = "Нет описания..."
        }
    }
}
