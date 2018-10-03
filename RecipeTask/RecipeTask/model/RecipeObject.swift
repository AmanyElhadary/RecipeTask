//
//  RecipeObject.swift
//  RecipeTask
//
//  Created by mac on 10/3/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RecipeObject:Mappable{
    var uri:String?
    var label:String?
    var image: String?
    var source: String?
    var url: String?
    var healthLabels:[String]?
    var ingredientLines:[String]?

    required init?(map: Map){

    }

    func mapping(map: Map) {
        uri <- map["uri"]
        label <- map["label"]
        image <- map["image"]
        source <- map["source"]
        url <- map["url"]
        healthLabels <- map["healthLabels"]
        ingredientLines <- map["ingredientLines"]

    }

}


