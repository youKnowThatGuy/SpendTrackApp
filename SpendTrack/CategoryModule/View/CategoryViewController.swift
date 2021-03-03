//
//  CategoryViewController.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var mockLabel: UILabel!
    
    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mockLabel.text = text
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
