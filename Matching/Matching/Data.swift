//
//  Data.swift
//  Matching
//
//  Created by 杉山佳史 on 2018/10/17.
//  Copyright © 2018 SUGIYOSI. All rights reserved.
//

import Foundation

class User:NSObject, NSCoding {
    
    var UserID: String?
    var UserName: String?
    var Email: String?
    var Password: String?
    var UserImage: NSData?
    var lives: Int = 0
    var sex: Bool = true
    var age: Int = 0
    var colleage: Int = 0
    var favorite: Int = 0
    
    override init() {
    }
    
    //デコード処理
    required init?(coder aDecoder: NSCoder) {
        UserID = aDecoder.decodeObject(forKey: "userid") as? String
        Email = aDecoder.decodeObject(forKey: "email") as? String
        Password = aDecoder.decodeObject(forKey: "password") as? String
        UserImage = aDecoder.decodeObject(forKey: "userimage") as? NSData
        lives = Int(aDecoder.decodeInt32(forKey: "lives"))
        sex = aDecoder.decodeBool(forKey: "sex") as Bool
        age = Int(aDecoder.decodeInt32(forKey: "age"))
        colleage = Int(aDecoder.decodeInt32(forKey: "colleage"))
        favorite = Int(aDecoder.decodeInt32(forKey: "favorite"))
    }
    
    //エンコード処理
    func encode(with aCoder: NSCoder){
        aCoder.encode(UserID, forKey: "userid")
        aCoder.encode(Email, forKey: "email")
        aCoder.encode(Password, forKey: "password")
        aCoder.encode(UserImage, forKey: "userimage")
        aCoder.encode(lives, forKey: "lives")
        aCoder.encode(sex, forKey: "sex")
        aCoder.encode(age,forKey: "age")
        aCoder.encode(colleage, forKey:"colleage")
        aCoder.encode(favorite, forKey: "favorite")
    }
}

//現在のユーザーデータと指定している本のデータを格納するシングルトン

final class NowUser{
    static let shared = NowUser()
    var nowuser = User()
    var tapUser = User()
    private init() {}
}
