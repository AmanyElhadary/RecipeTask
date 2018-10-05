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
    @IBOutlet var LoadingView: UIView!
    @IBOutlet var networkerrorView: UIView!
    @IBOutlet var NoSearchReusltView: noSearchResult!
    @IBOutlet var previousSerachDataView: previousRecipeSearch!

    
    private var StartSearchScope : Int = 0
    private var EndSearchScope :Int = 10
    private var colorarr:[UIColor] = [#colorLiteral(red: 0.9839747548, green: 0.6106206775, blue: 0.6113013625, alpha: 1),#colorLiteral(red: 0.6749841571, green: 0.8317873478, blue: 0.6982142329, alpha: 1),#colorLiteral(red: 0.9925311208, green: 0.7919388413, blue: 0.4030863643, alpha: 1),#colorLiteral(red: 0.5815034509, green: 0.6450933814, blue: 0.8088852763, alpha: 1),#colorLiteral(red: 0.9759518471, green: 0.8862283902, blue: 0.9973898472, alpha: 1)]
    private var nomoreData = false
    private var showSearchBar =  0
    private var searchtext = "chicken" // initial value
    var refreshRecipeData: UIRefreshControl!
    let RecipesearchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.alpha = 1
        // Do any additional setup after loading the view, typically from a nib.
        registerCell()
        GetRecipeSearchData()
        addrefresh()
        SetupSearchController()
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RecipeSearchVC.HideSearchPreviousDataView), name: Notification.Name("HideSearchPreviousDataView"), object: nil)

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RecipeSearchVC.SelectDataFromSearchBox(notification:)), name: Notification.Name("SelectDataFromSearchBox"), object: nil)

        RecipeSearchTable.estimatedRowHeight = 167
        RecipeSearchTable.rowHeight = UITableViewAutomaticDimension
    }
    @objc func HideSearchPreviousDataView(){
        self.previousSerachDataView.alpha = 0

    }
    @objc func SelectDataFromSearchBox(notification: NSNotification){
        if let searchtext = notification.userInfo?["Textselected"] as? String {
            RecipesearchController.searchBar.text = searchtext
            previousSerachDataView.alpha = 0
        }


    }
    func SetupSearchController (){

    // Setup the Search Controller
    RecipesearchController.searchResultsUpdater = self
    RecipesearchController.searchBar.delegate = self
    RecipesearchController.hidesNavigationBarDuringPresentation = false 

        if #available(iOS 9.1, *) {
            RecipesearchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
    RecipesearchController.searchBar.placeholder = "Search Recipe"
    RecipesearchController.searchBar.barTintColor = #colorLiteral(red: 0.9371048808, green: 0.9410254955, blue: 0.962559998, alpha: 1)
    RecipesearchController.searchBar.sizeToFit()
        // this hide search bar on next VC
    definesPresentationContext = true
    RecipesearchController.searchBar.text = "chicken"
    self.navigationItem.titleView = RecipesearchController.searchBar

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
        self.NoSearchReusltView.alpha = 0
        self.networkerrorView.alpha = 0
        if (RecipeData.count == 0 ){
            self.LoadingView.alpha = 1}
        else {self.LoadingView.alpha = 0}
        LoadingIndicator.alpha = 1
        LoadingIndicator.startAnimating()
    if Reachability.isConnectedToNetwork() == true {
        RecipeAPI.sharedInstance.PopularRequest(searchText: searchtext, From: StartSearchScope, To: EndSearchScope, completion: {
            Responsesucses,RecipeArray  in
            guard (Responsesucses) else {
                self.LoadingIndicator.alpha = 0
                self.LoadingView.alpha = 0
                self.NoSearchReusltView.alpha = 0
                self.networkerrorView.alpha = 1
                return
            }
            if (RecipeArray.count == 0)
            {

                guard (self.RecipeData.count != 0) else {
                    self.LoadingIndicator.alpha = 0
                    self.LoadingView.alpha = 0
                    self.NoSearchReusltView.alpha = 1
                    self.networkerrorView.alpha = 0
                    self.RecipeSearchTable.reloadData()
                    return
                }
                self.nomoreData = true
            }
            self.refreshRecipeData?.endRefreshing()
            self.LoadingIndicator.alpha = 0
            self.LoadingView.alpha = 0
            self.NoSearchReusltView.alpha = 0
            self.networkerrorView.alpha = 0
            self.LoadingIndicator.startAnimating()
            self.RecipeData.append(contentsOf: RecipeArray)
            self.RecipeSearchTable.reloadData()


        })
    
    }
    else
    {
        self.LoadingIndicator.alpha = 0
        self.LoadingView.alpha = 0
        self.NoSearchReusltView.alpha = 0
        self.networkerrorView.alpha = 1

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
        DetailVc.obj = RecipeData[indexPath.row]
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

extension RecipeSearchVC : UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if (Constants.UserDefaultHelper.getPreviousSearchData().count > 0){
        NotificationCenter.default.post(name: Notification.Name("ReloadPreviousSearchData"), object: nil)
        self.previousSerachDataView.alpha = 1
            
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.StartSearchScope = 0
        self.EndSearchScope = 10
        self.RecipeSearchTable.reloadData()
        self.previousSerachDataView.alpha = 0
        NotificationCenter.default.post(name: Notification.Name("ReloadPreviousSearchData"), object: nil)


    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.previousSerachDataView.alpha = 0
        self.StartSearchScope = 0
        self.EndSearchScope = 10
        self.nomoreData = false
        self.RecipeData.removeAll()
        searchBar.resignFirstResponder()
        if searchtext.count > 0 {
            Constants.UserDefaultHelper.setPreviousSearchData(searchText: searchtext)
            NotificationCenter.default.post(name: Notification.Name("ReloadPreviousSearchData"), object: nil)

            self.GetRecipeSearchData()

        }else {
            self.RecipeSearchTable.reloadData()
        }
    }


}
extension RecipeSearchVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchtext = text

    }




}
