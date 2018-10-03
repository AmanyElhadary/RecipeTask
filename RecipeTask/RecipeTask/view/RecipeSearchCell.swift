//
//  RecipeSearchCell.swift
//  RecipeTask
//
//  Created by mac on 10/3/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Haneke

class RecipeSearchCell: UITableViewCell {

    @IBOutlet var RecipeImg: UIImageView!
    @IBOutlet var RecipeNameLbl: UILabel!
    @IBOutlet var RecipeSourceLbl: UILabel!
    @IBOutlet var RecipeHealthLbl: UILabel!
    @IBOutlet var contentview: UIView!
    
    @IBOutlet var shadowImgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowImgView.dropShadow()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var RecipeObject_ : RecipeObject? {
        didSet {
            guard let RecipeObject = RecipeObject_ else { return }

            self.RecipeImg.image = nil
            if let mainImg = RecipeObject.image {

                if let mainImageURL = URL(string: mainImg){
                    self.RecipeImg.hnk_setImageFromURL(mainImageURL)

                }
            }
            if let RecipeName = RecipeObject.label {
                self.RecipeNameLbl.text = RecipeName
            }
            if let RecipeSource = RecipeObject.source {
                self.RecipeSourceLbl.text = RecipeSource
            }
            if let RecipeHealth = RecipeObject.healthLabels {
                var RecipeStr = ""
                for data in RecipeHealth{
                        RecipeStr += "\(data)\n"
                }
                self.RecipeHealthLbl.text = RecipeStr
            }

        }
    }

    
}
