//
//  RecipeDetailsVC.swift
//  RecipeTask
//
//  Created by mac on 10/3/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import SafariServices
import ActiveLabel

class RecipeDetailsVC: UIViewController {

    @IBOutlet var RecipeImg: UIImageView!
    @IBOutlet var RecipeName: UILabel!
    @IBOutlet var RecipeingredientLines: UILabel!
    @IBOutlet var Recipelink: ActiveLabel!
    var obj:RecipeObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        FillDetails()

        // Do any additional setup after loading the view.
    }
    func FillDetails(){
        if let RecipeName = obj?.label {
            self.RecipeName.text = RecipeName
        }
        if let RecipeLink = obj?.url {
            Recipelink.text = RecipeLink
            Recipelink.handleURLTap { url in
                self.UrlClicked(url: url)
            }
        }
        if let RecipeName = obj?.label {
            self.RecipeName.text = RecipeName
        }
        if let RecipeingredientLines = obj?.ingredientLines {
            var RecipeStr = ""
            for data in RecipeingredientLines{
                RecipeStr += "\(data)\n"
            }
            self.RecipeingredientLines.text = RecipeStr
        }

        if let mainImg = obj?.image {

            if let mainImageURL = URL(string: mainImg){
                self.RecipeImg.hnk_setImageFromURL(mainImageURL)

            }
        }
    }

    func UrlClicked(url :URL){
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            present(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RecipeDetailsVC : SFSafariViewControllerDelegate{

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }

}
