//
//  Constants.swift
//  RecipeTask
//
//  Created by mac on 10/3/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit

class Constants: NSObject {
    struct  KeysAndValues {
        static let KEY_APPID = "891e21ef"
        static let KEY_APPKEY = "73392a19085f38fad7af987eb33ef032"
    }
    struct WebService {
        static let URLBASE = "https://api.edamam.com/search"
    }
    struct FontHelper {
        static func defaultRegularFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: "DINNextLTArabic-Regular", size: size)!
        }
        static func defaultBoldFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: "DINNextLTArabic-Regular", size: size)!
        }
    }
    struct UserDefaultHelper {
        static let PerviousSearchDataCount = 10
        static let StoredUserDefaultKey = "SavedPrevoiusSearchArray"

    static func userAlreadyExist(kUsernameKey: String) -> Bool {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }
       static func setPreviousSearchData(searchText: String){
            if (userAlreadyExist(kUsernameKey: UserDefaultHelper.StoredUserDefaultKey))
            {
                var myStoredArr = UserDefaults.standard.stringArray(forKey: UserDefaultHelper.StoredUserDefaultKey) ?? [String]()
                guard (myStoredArr.contains(searchText))
                    else {
                if (myStoredArr.count == UserDefaultHelper.PerviousSearchDataCount)
                {
                    myStoredArr.removeLast()
                }
                    myStoredArr.insert(searchText, at: 0)
                    UserDefaults.standard.set(myStoredArr, forKey: UserDefaultHelper.StoredUserDefaultKey)
                        return
                }
                let FoundedIndex = myStoredArr.index(of: searchText)
                myStoredArr.remove(at: FoundedIndex!)
                myStoredArr.insert(searchText, at: 0)
                UserDefaults.standard.set(myStoredArr, forKey: UserDefaultHelper.StoredUserDefaultKey)
            }
            else
            {
                var PrevoisSearchArr = [String]()
                PrevoisSearchArr.insert(searchText, at: 0)
                UserDefaults.standard.set(PrevoisSearchArr, forKey: UserDefaultHelper.StoredUserDefaultKey)

            }

        }
       static func getPreviousSearchData() -> [String]{

            guard (userAlreadyExist(kUsernameKey: UserDefaultHelper.StoredUserDefaultKey)) else {
                return []
            }
            return UserDefaults.standard.stringArray(forKey: UserDefaultHelper.StoredUserDefaultKey) ?? [String]()
            
        }



    }
    
}
