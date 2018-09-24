//
//  Data.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/19.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import Foundation


class BookData: NSObject, NSCoding {
    
    //タイトル、作者、本の画像、本のレビューの格納
    var BookTitle: String?
    var Author: String?
    var BookViews:[String:String] = [:]
    var BookImage: NSData?
    
    override init() {
    }
    
    //デコード処理
    required init?(coder aDecoder: NSCoder) {
        BookTitle = aDecoder.decodeObject(forKey: "booktitle") as? String
        Author = aDecoder.decodeObject(forKey: "author") as? String
        BookImage = aDecoder.decodeObject(forKey: "bookimage") as? NSData
        guard let low = aDecoder.decodeObject(forKey: "bookview") as? [String: String] else { return }
        BookViews = low
    }
    
    //エンコード処理
    func encode(with aCoder: NSCoder){
        aCoder.encode(BookTitle, forKey: "booktitle")
        aCoder.encode(Author, forKey: "author")
        aCoder.encode(BookViews, forKey: "bookview")
        aCoder.encode(BookImage, forKey: "bookimage")
    }
}



class User: NSObject, NSCoding {
    
    var UserID: String?
    var Email: String?
    var Password: String?
    var UserImage: NSData?
    
    override init() {
    }
    
    //デコード処理
    required init?(coder aDecoder: NSCoder) {
        UserID = aDecoder.decodeObject(forKey: "userid") as? String
        Email = aDecoder.decodeObject(forKey: "email") as? String
        Password = aDecoder.decodeObject(forKey: "password") as? String
        UserImage = aDecoder.decodeObject(forKey: "userimage") as? NSData
        
    }
    
    //エンコード処理
    func encode(with aCoder: NSCoder){
        aCoder.encode(UserID, forKey: "userid")
        aCoder.encode(Email, forKey: "email")
        aCoder.encode(Password, forKey: "password")
        aCoder.encode(UserImage, forKey: "userimage")
    }
}


