//
//  previousRecipeSearch.swift
//  RecipeTask
//
//  Created by mac on 10/4/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit

class previousRecipeSearch: UIView {
     var RecipePreviousSearchData : [String]?
    @IBOutlet var prviousSearchTable: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var contentView : UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        contentView = loadViewFromNib()

        // use bounds not frame or it'll be offset
        contentView!.frame = bounds

        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }

    func loadViewFromNib() -> UIView! {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        RecipePreviousSearchData = Constants.UserDefaultHelper.getPreviousSearchData()
        prviousSearchTable.register(UINib(nibName: "searchcell", bundle: nil), forCellReuseIdentifier: "searchcell")

        prviousSearchTable.delegate = self
        prviousSearchTable.dataSource = self
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(previousRecipeSearch.Reloadtable), name: Notification.Name("ReloadPreviousSearchData"), object: nil)
        return view
    }
   @objc func Reloadtable (){
        RecipePreviousSearchData = Constants.UserDefaultHelper.getPreviousSearchData()
        prviousSearchTable.reloadData()
    }

}
extension previousRecipeSearch : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


    }


}
extension previousRecipeSearch : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipePreviousSearchData!.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell")
        cell?.textLabel?.text = self.RecipePreviousSearchData?[indexPath.row]
        return cell!
    }

}
