//
//  HomeViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/19.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    
    var Bookers = [BookData]()
    var myBookers = [BookData]()
    var Book = BookData()
    var user = User()
    
    private var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        
        
        if user.UserID == nil {
            goNext()
        }
        
        
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        for book in Bookers {
            for (key,value) in book.BookViews{
                if value == user.UserID{
                    book.BookViews.removeAll()
                    book.BookViews.updateValue(user.UserID!, forKey: key)
                    myBookers.append(book)
                }
            }
        }
        
        //テーブルビューの設定
        
        //テーブルビューの初期化
        tableview = UITableView()
        //デリゲートの設定
        tableview.delegate = self
        tableview.dataSource = self
        
        
        //サーチバーの高さだけ初期位置を下げる
        tableview.contentOffset = CGPoint(x: 0,y :44)
        
        
        //ナビゲーションバーの設定
        let myNavBar = UINavigationBar()
        //大きさの指定
        myNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        //タイトル、虫眼鏡ボタンの作成
        let myNavItems = UINavigationItem()
        myNavItems.title = user.UserID
        let rightNavBtn =  UIBarButtonItem(title: "Logout",style: .plain,target: self, action: #selector(rightBarBtnClicked(sender:)))
        myNavItems.leftBarButtonItem = rightNavBtn
        rightNavBtn.action = #selector(rightBarBtnClicked(sender:))
        myNavItems.rightBarButtonItem = rightNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
    
        
        let leftNavBtn =  UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(leftBarBtnClicked(sender:)))
        
        leftNavBtn.action = #selector(leftBarBtnClicked(sender:))
        myNavItems.leftBarButtonItem = leftNavBtn
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        //テーブルビューの大きさの指定
        tableview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + myNavBar.frame.height, width: viewWidth, height: viewHeight - UIApplication.shared.statusBarFrame.height-myNavBar.frame.height)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableview.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableview)
        
        
        
    }
    
    
    @objc func goNext() {
        let vc = LoginViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc internal func rightBarBtnClicked(sender: UIButton){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc internal func leftBarBtnClicked(sender: UIButton){
        let vc = SearchViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //テーブルビューのメソッド
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセルの数はSearchResult配列の数とした
        return myBookers.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SearchResult配列の中身をテキストにして登録した
       // let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
       let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        var KEY: String = String()
        var IMAGE: UIImage?
        var TITLE: String = String()
      //  let IMAGE: UIImage? = UIImage(data: Books.BookImage! as Data)

        
        for(key,value) in myBookers[indexPath.row].BookViews {
            if value == user.UserID {
                KEY = key
                if myBookers[indexPath.row].BookImage != nil{
                    IMAGE = UIImage(data: myBookers[indexPath.row].BookImage! as Data)
                }
                //IMAGE = UIImage(data: myBookers[indexPath.row].BookImage! as Data)
                TITLE = myBookers[indexPath.row].BookTitle!
            }
        }
        
        cell.textLabel?.text = KEY
        if IMAGE != nil{
            cell.imageView?.image = IMAGE?.resize(size: CGSize(width: 50, height: 50))
        }
        cell.detailTextLabel?.text = TITLE
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ////Bookersの各BookTitleを参照し,searchResult[indexPath.row]と同じ物のObjectを持ってくる。
        Book =  Bookers[indexPath.row]
        
        
        
        
        //上の処理で持ってきた、BookData型のBookaを次の画面へ持っていく
        let vc = BookViewController()
        vc.Books = Book
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK: テーブルビューのセルを削除する処理
    //    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
    //        //削除可能かどうか
    //        if editingStyle == UITableViewCellEditingStyle.delete {
    //            //Bookersの各BookTitleを参照し、削除するセルと同じ名前のObjectを削除する（あまり良く無いのかも）
    //            for book in Bookers {
    //                if let title = book.BookTitle {
    //                    if title == searchResult[indexPath.row] {
    //                        let index: Int = Bookers.index(of: book)!
    //                        Bookers.remove(at: index)
    //                    }
    //                }
    //            }
    //            //searchResultも削除
    //            searchResult.remove(at: indexPath.row)
    //            //セルを削除
    //            tableview.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    //
    //
    //            //デシリアライズ処理（Bookers）
    //            let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
    //            let userDefaults = UserDefaults.standard
    //            userDefaults.set(data, forKey: "Bookers")
    //            userDefaults.synchronize()
    //        }
    //    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
