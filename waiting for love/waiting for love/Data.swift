//
//  Data.swift
//  waiting for love
//
//  Created by 杉山佳史 on 2018/09/13.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import Foundation

class BookData: NSObject, NSCoding {
    
    //タイトル、作者、本の画像、本のレビューの格納
    var BookTitle: String?
    var Author: String?
    var BookView:[String] = []
    var BookImage: NSData?
    
    override init() {
    }
    
    //デコード処理
    required init?(coder aDecoder: NSCoder) {
        BookTitle = aDecoder.decodeObject(forKey: "booktitle") as? String
        Author = aDecoder.decodeObject(forKey: "author") as? String
        BookImage = aDecoder.decodeObject(forKey: "bookimage") as? NSData
        guard let low = aDecoder.decodeObject(forKey: "bookview") as? [String] else { return }
        BookView = low
    }
    
    //エンコード処理
    func encode(with aCoder: NSCoder){
        aCoder.encode(BookTitle, forKey: "booktitle")
        aCoder.encode(Author, forKey: "author")
        aCoder.encode(BookView, forKey: "bookview")
        aCoder.encode(BookImage, forKey: "bookimage")
    }
}

