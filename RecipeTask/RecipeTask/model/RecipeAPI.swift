//
//  RecipeAPI.swift
//  RecipeTask
//
//  Created by mac on 10/3/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RecipeAPI: NSObject {
    static let sharedInstance: RecipeAPI = RecipeAPI()
    func PopularRequest( searchText : String ,From : Int , To : Int , completion: @escaping (_ sucses: Bool  , _ ResultArr: [RecipeObject])->()){
        var RecipeArr = [RecipeObject]()
        let parameters: Parameters = [:
            ]
        let api = "\(Constants.WebService.URLBASE)?q=\(searchText)&app_id=\(Constants.KeysAndValues.KEY_APPID)&app_key=\(Constants.KeysAndValues.KEY_APPKEY)&from=\(From)&to=\(To)"
        Alamofire.request(api, method: .get , parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let result = response.result.value else {
                        completion(true,[])
                        return
                    }
                    guard let RstultDic = result as? NSDictionary else {
                        completion(true,[])
                        return
                    }
                    guard let data = RstultDic["hits"]as? NSArray else {
                        completion(true,[])
                        return
                    }
                    for obj in data  {
                        if let objDic = obj as? NSDictionary  {

                        guard let Recipeobj = objDic["recipe"]as? NSDictionary else {
                            completion(true,[])
                            return
                        }
                        guard let singleObj  = Mapper<RecipeObject>().map(JSONObject: Recipeobj)
                            else {
                                completion(true,[])
                                return
                        }
                        RecipeArr.append(singleObj)
                        }
                    }
                    completion(true,RecipeArr)

                case .failure(let error):
                    print("Requesterror: \(error)")
                    completion(false,[])
                }
        }


    }
}
