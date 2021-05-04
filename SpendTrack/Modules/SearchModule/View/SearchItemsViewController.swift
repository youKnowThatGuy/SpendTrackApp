//
//  SearchItemsViewController.swift
//  SpendTrack
//
//  Created by Клим on 24.04.2021.
//
import UIKit


protocol SuggestedSearch: class {
    // A suggested search was selected; inform our delegate that the selected search token was selected.
    func didSelectSuggestedSearch(word: String)
}



class SearchItemsViewController: UITableViewController {
    
  weak var suggestedSearchDelegate: SuggestedSearch?

  var suggestedSearches: [String] = []
    
    var showSuggestedSearches: Bool = false {
        didSet {
            if oldValue != showSuggestedSearches {
                tableView.reloadData()
            }
        }
    }

    func updateSearchTable(newSearch: String){
        if (suggestedSearches.count >= 5){
            suggestedSearches.removeLast()
        }
        suggestedSearches.insert(newSearch, at: 0)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedSearches.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return showSuggestedSearches ? NSLocalizedString("Вы искали:", comment: "") : ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "suggestCell")

        if showSuggestedSearches {
            let suggestedtitle = NSMutableAttributedString(string: suggestedSearches[indexPath.row])
        
            cell.textLabel?.attributedText = suggestedtitle
            cell.textLabel?.font = UIFont(name: "DIN Alternate Bold", size: 18)
            let image = resizeImage(image: UIImage(named: "searched")!, targetSize: CGSize(width: 20, height: 20))
            cell.imageView?.image = image
            
            // No detailed text or accessory for suggested searches.
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            suggestedSearches.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CachingService.shared.cacheSearches(suggestedSearches.joined(separator: ", "))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We must have a delegate to respond to row selection.
        guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
            
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Make sure we are showing suggested searches before notifying which token was selected.
        if showSuggestedSearches {
            // A suggested search was selected; inform our delegate that the selected search token was selected.
            let wordToInsert = suggestedSearches[indexPath.row]
            suggestedSearchDelegate.didSelectSuggestedSearch(word: wordToInsert)
        }
    }




}
