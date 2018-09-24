//
//  ViewController.swift
//  waiting for love
//
//  Created by 杉山佳史 on 2018/09/10.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    //BookData型の配列
    var Bookers = [BookData]()
    //BookData型のオブジェクト
    var Booka = BookData()
    //SearchBarインスタンス
    private var searchbar: UISearchBar!
    //テーブルビューインスタンス
    private var tableview: UITableView!
    
    //検索結果が入る配列
    var searchResult: Array = Array<String>()
    var myItems     : Array = Array<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //シリアライズ処理（Bookers）
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
    
        //UINavigationControllerでできたナビゲーションバーを非表示にする
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        

        //Bookersの各BookTitleをsearchResultに格納する
        for book in Bookers {
            if let title = book.BookTitle {
                searchResult.append(title)
            }
        }
        
        //myItemsにsearchResltに代入する
        myItems = searchResult
        
        //Viewの大きさを取得
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        
        
        // NavigationBar関連について書く
        
        //UINavigationBarを作成
        let NavBar = UINavigationBar()
        //大きさの指定
        NavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        //NavigationBarItemの宣言
        let NavItems = UINavigationItem()
         //タイトルの作成
        NavItems.title = "本検索"
        
        //右上にある検索ボタンの設定する
        let rightNavBtn =  UIBarButtonItem(barButtonSystemItem:  .search, target: self, action: #selector(rightBarBtnClicked(sender:)))
        NavItems.leftBarButtonItem = rightNavBtn
        rightNavBtn.action = #selector(rightBarBtnClicked(sender:))
        NavItems.rightBarButtonItem = rightNavBtn;
        NavBar.pushItem(NavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(NavBar)
        
        //左上にある追加ボタンの設定をする
        let leftNavBtn =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(leftBarBtnClicked(sender:)))
        leftNavBtn.action = #selector(leftBarBtnClicked(sender:))
        NavItems.leftBarButtonItem = leftNavBtn;
        NavBar.pushItem(NavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(NavBar)
        
        
        // SearchBar関連について書く
        
        //SearchBarの作成
        searchbar = UISearchBar()
        //デリゲートを設定
        searchbar.delegate = self
        //大きさの指定
        searchbar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        //キャンセルボタンの追加
        searchbar.showsCancelButton = true
        
        
        //TableView関連について書く
        
        //テーブルビューの初期化
        tableview = UITableView()
        //デリゲートの設定
        tableview.delegate = self
        tableview.dataSource = self
        //テーブルビューの大きさの指定
        tableview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + NavBar.frame.height, width: viewWidth, height: viewHeight - UIApplication.shared.statusBarFrame.height-NavBar.frame.height)
        //先ほど作成したSearchBarを作成
        tableview.tableHeaderView = searchbar
        //サーチバーの高さだけ初期位置を下げる
        tableview.contentOffset = CGPoint(x: 0,y :44)
        
        //テーブルビューの設置
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableview)
    }
    
    
    
    
    //MARK: - ナビゲーションバーの右の虫眼鏡が押されたら呼ばれるメソッド
    @objc internal func rightBarBtnClicked(sender: UIButton){
        tableview.contentOffset = CGPoint(x: 0,y :0)
    }
    
    
    
    //MARK: - ナビゲーションバーの左の追加ボタンが押されたら呼ばれるメソッド
    @objc internal func leftBarBtnClicked(sender: UIButton){
        let alertController = UIAlertController(title: "追加", message: "本の名前を追加して下さい", preferredStyle: UIAlertControllerStyle.alert)
        //テキストエリア(本のタイトル)を追加
        alertController.addTextField(configurationHandler: nil)
        
        //okボタンが押された場合
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
               
                let booker = BookData()
                booker.BookTitle = textField.text!
                
                 //配列の先頭に入力値を挿入、searchresult,myItemにも挿入
                self.Bookers.insert(booker, at: 0)
                self.myItems.insert(textField.text!, at: 0)
                self.searchResult = self.myItems
                
                //デシリアライズ 処理（Bookers）
                let data: Data = NSKeyedArchiver.archivedData(withRootObject: self.Bookers)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey: "Bookers")
                userDefaults.synchronize()
                
                //行が追加された事をテーブルに通知　これを行う事で　UITableViewの再描画処理が行われ、実際の画面に新しい項目が追加されることになります
                self.tableview.insertRows(at: [IndexPath(row: 0,section: 0)], with: UITableViewRowAnimation.right)
                
                
                
            }
        }
        
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler: nil)
        //キャンセルボタンを追加
        alertController.addAction(cancelButton)
        //アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - 渡された文字列を含む要素を検索し、テーブルビューを再表示する
    func searchItems(searchText: String){
        
        //要素を検索する
        if searchText != "" {
            searchResult = myItems.filter { myItem in
                return (myItem ).contains(searchText)
                } as Array
            
        }else{
            //渡された文字列が空の場合は全てを表示
            searchResult = myItems
        }
        
        //tableViewを再読み込みする
        tableview.reloadData()
    }
    
    
    
    //SearchBarのデリゲードメソッドたち
    
    //MARK: 検索しているとき、テキストが変更される毎に呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //検索する
        searchItems(searchText: searchText)
    }
    
    //MARK: 検索バーのキャンセルボタンが押されると呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchbar.text = ""
        self.view.endEditing(true)
        searchResult = myItems
        
        //tableViewを再読み込みする
        tableview.reloadData()
    }
    
    //MARK: 検索バーのSearchボタンが押されると呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        //検索する
        searchItems(searchText: searchbar.text! as String)
    }
    
    
    //テーブルビューのデリゲードメソッドたち
    
    //MARK: テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセルの数はSearchResult配列の数とした
        return self.searchResult.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SearchResult配列の中身をテキストにして登録した
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.searchResult[indexPath.row]
        
        return cell
    }
    
    //MARK: テーブルビューのセルを削除する処理
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //削除可能かどうか
        if editingStyle == UITableViewCellEditingStyle.delete {
            //Bookersの各BookTitleを参照し、削除するセルと同じ名前のObjectを削除する（あまり良く無いのかも）
            for book in Bookers {
                if let title = book.BookTitle {
                    if title == searchResult[indexPath.row] {
                        let index: Int = Bookers.index(of: book)!
                        Bookers.remove(at: index)
                    }
                }
            }
            //searchResultも削除
            searchResult.remove(at: indexPath.row)
            //セルを削除
            tableview.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            
            //デシリアライズ処理（Bookers）
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "Bookers")
            userDefaults.synchronize()
        }
    }

    
    
    //Mark: テーブルビューのセルが押されたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ////Bookersの各BookTitleを参照し,searchResult[indexPath.row]と同じ物のObjectを持ってくる。
        for book in Bookers {
            if let title = book.BookTitle {
                if title == searchResult[indexPath.row] {
                    Booka = book
                }
            }
        }
        
        //上の処理で持ってきた、BookData型のBookaを次の画面へ持っていく
        let vc = BookViewController()
            vc.Books = Booka
        navigationController?.pushViewController(vc, animated: true)

    }
}
