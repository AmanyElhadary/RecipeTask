//
//  ViewController.swift
//  RecipeTask
//
//  Created by mac on 10/3/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit

class RecipeSearchVC: UIViewController {
    var RecipeData : [RecipeObject] = [RecipeObject]()
    @IBOutlet var RecipeSearchTable: UITableView!
    @IBOutlet var LoadingIndicator: UIActivityIndicatorView!
    private var StartSearchScope : Int = 0
    private var EndSearchScope :Int = 10
    private var colorarr:[UIColor] = [#colorLiteral(red: 0.9839747548, green: 0.6106206775, blue: 0.6113013625, alpha: 1),#colorLiteral(red: 0.6749841571, green: 0.8317873478, blue: 0.6982142329, alpha: 1),#colorLiteral(red: 0.9925311208, green: 0.7919388413, blue: 0.4030863643, alpha: 1),#colorLiteral(red: 0.5815034509, green: 0.6450933814, blue: 0.8088852763, alpha: 1),#colorLiteral(red: 0.9759518471, green: 0.8862283902, blue: 0.9973898472, alpha: 1)]
    private var nomoreData = false
    var refreshRecipeData: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerCell()
        GetRecipeSearchData()
        addrefresh()
        RecipeSearchTable.estimatedRowHeight = 167
        RecipeSearchTable.rowHeight = UITableViewAutomaticDimension
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addrefresh(){
        refreshRecipeData = UIRefreshControl()
        refreshRecipeData.addTarget(self, action:  #selector(RecipeSearchVC.refreshRecipeData(_:)), for: UIControlEvents.valueChanged)
        refreshRecipeData.tintColor = #colorLiteral(red: 0.6007973552, green: 0.1939866245, blue: 0.4056833386, alpha: 1)
        RecipeSearchTable.addSubview(refreshRecipeData)

    }
    @objc func refreshRecipeData(_ sender:AnyObject){
        self.RecipeData.removeAll()
        self.StartSearchScope = 0
        self.EndSearchScope = 10
        self.GetRecipeSearchData()
    }
    func registerCell() {
        RecipeSearchTable.register(UINib(nibName: "RecipeSearchCell", bundle: nil), forCellReuseIdentifier: "RecipeSearchCell")

    }


    func GetRecipeSearchData () {
        LoadingIndicator.alpha = 1
        LoadingIndicator.startAnimating()
    if Reachability.isConnectedToNetwork() == true {
        RecipeAPI.sharedInstance.PopularRequest(searchText: "chicken", From: StartSearchScope, To: EndSearchScope, completion: {
            Responsesucses,RecipeArray  in
            guard (Responsesucses) else {
                return
            }
            if (RecipeArray.count == 0)
            {
                self.nomoreData = true
            }
            self.refreshRecipeData?.endRefreshing()
            self.LoadingIndicator.alpha = 0
            self.LoadingIndicator.startAnimating()
            self.RecipeData.append(contentsOf: RecipeArray)
            self.RecipeSearchTable.reloadData()


        })
    
    }
    else
    {


    }

    }


}
extension RecipeSearchVC : UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {


        let lastrow = tableView.numberOfRows(inSection: 0)
        if(indexPath.row == lastrow - 1 ){
            if (nomoreData == true )
            {
                // moke toast no more data
            }
            else {
            self.StartSearchScope = EndSearchScope
            self.EndSearchScope = EndSearchScope + 10
            self.GetRecipeSearchData()
            }

        }


    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DetailVc = mainStoryBoard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
        self.navigationController?.pushViewController(DetailVc, animated: true)

    }


}

extension RecipeSearchVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return RecipeData.count

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeSearchCell") as! RecipeSearchCell
        let RecipeObject: RecipeObject
        if RecipeData.count > 0 {
                RecipeObject = RecipeData[indexPath.row]
                cell.RecipeObject_ = RecipeObject
        }
        let currentcolor:UIColor = colorarr[indexPath.row % colorarr.count]
        cell.contentview.backgroundColor = currentcolor
        let backgroundView = UIView()
        backgroundView.backgroundColor = currentcolor
        cell.selectedBackgroundView = backgroundView
        return cell
    }



}

