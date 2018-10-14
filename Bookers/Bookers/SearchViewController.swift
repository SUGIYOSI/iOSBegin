//
//  SearchViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/19.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var Bookers = [BookData]()
    var Booka = BookData()
    private var searchbar: UISearchBar!
    private var tableview: UITableView!
    
    //検索結果が入る配列
    var searchResult: Array = Array<String>()
    var myItems     : Array = Array<String>()
    
    let SafeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        return view
    }()
    
     override func viewWillAppear(_ animated: Bool) {
        myItems.removeAll()
        searchResult.removeAll()
        Bookers.removeAll()
        Booka = BookData()
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        //Bookersの各BookTitleをsearchResultに格納する
        for book in Bookers {
            if let title = book.BookTitle {
                searchResult.append(title)
            }
        }
        
        //myItemsにsearchResltに代入する
        myItems = searchResult
        tableview.reloadData()
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //UINavigationControllerでできたナビゲーションバーを非表示にする
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //Viewの大きさを取得
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        
        
        // NavigationBar関連について書く
        
        //UINavigationBarを作成
        let NavBar = UINavigationBar()
        NavBar.isTranslucent = false
        NavBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1) 

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
        
        // SearchBar関連について書く
        
        //SearchBarの作成
        searchbar = UISearchBar()
        //デリゲートを設定
        searchbar.delegate = self
        //大きさの指定
        searchbar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        //キャンセルボタンの追加
        searchbar.showsCancelButton = true
        searchbar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        
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
        tableview.register(SearchCustomCell.self, forCellReuseIdentifier: "SearchCustomCell")
        tableview.rowHeight = 70
        self.view.addSubview(tableview)
        self.view.addSubview(SafeView)
        
        SafeView.translatesAutoresizingMaskIntoConstraints = false
        SafeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SafeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        SafeView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
    }
    
    
    
    
    //MARK: - ナビゲーションバーの右の虫眼鏡が押されたら呼ばれるメソッド
    @objc internal func rightBarBtnClicked(sender: UIButton){
        tableview.contentOffset = CGPoint(x: 0,y :0)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCustomCell",for: indexPath as IndexPath) as! SearchCustomCell
        
        //let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        var IMAGE: UIImage?
        //  let IMAGE: UIImage? = UIImage(data: Books.BookImage! as Data)
        
        for book in Bookers {
            if searchResult[indexPath.row] == book.BookTitle{
                if let image = book.BookImage {
                    IMAGE = UIImage(data: image as Data)
                }
            }
        }
            
            
        
        cell.titleLabel.text = searchResult[indexPath.row]
        if IMAGE != nil{
            cell.bookimage.image = IMAGE?.resize(size: CGSize(width: 50, height: 50))
        }else{
            cell.bookimage.image = UIImage(named: "NoImage")?.resize(size: CGSize(width: 50, height: 50))
        }
        
        cell.layoutIfNeeded()
        
        cell.titleLabel.text = searchResult[indexPath.row]
    
        
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
            tableview.reloadData()
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
        NowUser.shared.nowbook = Booka
        navigationController?.pushViewController(vc, animated: true)
        
    }
}




class SearchCustomCell: UITableViewCell {
    
    
    let bookimage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        return image
    }()
    
    let titleLabel: UILabel = {
        let Label = UILabel()
        Label.font = UIFont.italicSystemFont(ofSize: 17)
        Label.adjustsFontSizeToFitWidth = true
        Label.textAlignment = .center
        Label.layer.cornerRadius = 0
        Label.layer.masksToBounds = true
        return Label
    }()
    
    
    // よくわからんけど、必要
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 引数のないコンストラクタみたいなもの。
    // インスタンスが生成されたときに動く関数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        // contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(40, 40, 40, 40))
        let viewHeight10 = self.contentView.frame.height / 10
        let viewWidth22 = self.contentView.frame.width / 22
        // とりあえず、labelを作成してcontentViewにadd
        
       
        self.contentView.addSubview(bookimage)
        self.contentView.addSubview(titleLabel)
        
        bookimage.translatesAutoresizingMaskIntoConstraints = false
        bookimage.topAnchor.constraint(equalTo:contentView.topAnchor, constant: viewHeight10 * 2).isActive = true
        bookimage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: viewWidth22 * 2).isActive = true
        bookimage.widthAnchor.constraint(equalToConstant: viewWidth22 * 8).isActive = true
        bookimage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewHeight10 * 2).isActive = true
        
        
//        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
//        reviewLabel.topAnchor.constraint(equalTo:bookimage.topAnchor).isActive = true
//        reviewLabel.leadingAnchor.constraint(equalTo: bookimage.trailingAnchor,constant: viewWidth22 * 2).isActive = true
//        reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -viewWidth22 * 2).isActive = true
//        reviewLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo:bookimage.topAnchor, constant: viewHeight10 * 4).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookimage.trailingAnchor,constant: viewWidth22 * 3.5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -viewWidth22 * 3.5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -viewHeight10 * 4).isActive = true
        
        
    }
}
