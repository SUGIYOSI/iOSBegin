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
    var saveBook = BookData()
    var user = User()
    var IMAGE = UIImage()
    let myNavBar = UINavigationBar()
    private var tableview: UITableView!
    
    let SafeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        if NowUser.shared.nowuser.UserID == nil {
            goNext()
            return
        }
        user = NowUser.shared.nowuser
        myBookers.removeAll()
        Bookers.removeAll()
        saveBook = BookData()
        Book = BookData()
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        
        for book in Bookers {
            for (key,value) in book.BookViews{
                if value == user.UserID{
                    saveBook = book
                    saveBook.BookViews.removeAll()
                    saveBook.BookViews.updateValue(value, forKey: key)
                    myBookers.append(saveBook)
                }
            }
        }
        
        reloadNav()
        tableview.reloadData()
        myNavBar.setNeedsLayout()
        super.viewWillAppear(animated)
    }
    
    @objc func reloadNav(){
        
        let viewWidth = self.view.frame.size.width
        myNavBar.isTranslucent = false
        myNavBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        myNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        let myNavItems = UINavigationItem()
        myNavItems.title = user.UserID
        let rightNavBtn =  UIBarButtonItem(title: "" , style: .plain,target: self, action: nil)
        myNavItems.leftBarButtonItem = rightNavBtn
        myNavItems.rightBarButtonItem = rightNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        if user.UserImage == nil {
            IMAGE = UIImage(named: "NoImage")!.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }else{
            IMAGE = (UIImage(data: user.UserImage! as Data)?.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))!
        }
        
        let button = UIButton(type: .system)
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(IMAGE ,  for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        let leftBarButtonItem = UIBarButtonItem(customView: button)
        
        
        myNavItems.leftBarButtonItem = leftBarButtonItem
        myNavBar.pushItem(myNavItems, animated: true)
        self.view.addSubview(myNavBar)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        //テーブルビューの初期化
        tableview = UITableView()
        //デリゲートの設定
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 100
        //大きさの指定
        myNavBar.isTranslucent = false
        myNavBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1) 
        myNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        let myNavItems = UINavigationItem()
        myNavItems.title = user.UserID
        let rightNavBtn =  UIBarButtonItem(title: "" , style: .plain ,target: self, action: nil)
        myNavItems.leftBarButtonItem = rightNavBtn
        myNavItems.rightBarButtonItem = rightNavBtn
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)

        
        if user.UserImage == nil {
            IMAGE = UIImage(named: "NoImage")!.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }else{
            IMAGE = (UIImage(data: user.UserImage! as Data)?.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))!
        }
        
         let button = UIButton(type: .system)
         button.semanticContentAttribute = .forceRightToLeft
         button.setImage(IMAGE ,  for: .normal)
         let leftBarButtonItem = UIBarButtonItem(customView: button)
        
        
         myNavItems.leftBarButtonItem = leftBarButtonItem
         myNavBar.pushItem(myNavItems, animated: true)
         self.view.addSubview(myNavBar)
        
        //テーブルビューの大きさの指定
        tableview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + myNavBar.frame.height, width: viewWidth, height: viewHeight - UIApplication.shared.statusBarFrame.height-myNavBar.frame.height)
        tableview.register(HomeCustomCell.self, forCellReuseIdentifier: "HomeCustomCell")
        
        self.view.addSubview(tableview)
        
        self.view.addSubview(SafeView)
        SafeView.translatesAutoresizingMaskIntoConstraints = false
        SafeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SafeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        SafeView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
    }

    //ログインしてない場合の処理
    @objc func goNext() {
        let nc = UINavigationController(rootViewController: LoginViewController())
        self.present(nc, animated: true, completion: nil)
    }
    
    
    //テーブルビューのメソッド
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセルの数はSearchResult配列の数とした
        return myBookers.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCustomCell",for: indexPath as IndexPath) as! HomeCustomCell
        var KEY: String = String()
        var IMAGE: UIImage?
        var TITLE: String = String()

        for(key,value) in myBookers[indexPath.row].BookViews {
            if value == user.UserID {
                KEY = key
                if myBookers[indexPath.row].BookImage != nil{
                    IMAGE = UIImage(data: myBookers[indexPath.row].BookImage! as Data)
                }
                TITLE = myBookers[indexPath.row].BookTitle!
            }
        }
        
        cell.reviewLabel.text = KEY
        
        if IMAGE != nil{
            cell.bookimage.image = IMAGE?.resize(size: CGSize(width: 50, height: 50))
        }else{
            cell.bookimage.image =  UIImage(named: "NoImage")?.resize(size: CGSize(width: 50, height: 50))
        }
        
        cell.titleLabel.text = TITLE
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //ここを変更する
        Bookers.removeAll()
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        for book in Bookers {
            if book.BookTitle == myBookers[indexPath.row].BookTitle{
                NowUser.shared.nowbook = book
            }
        }
        
        let vc = BookViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class HomeCustomCell: UITableViewCell {
    
    let reviewLabel:UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        return textview
    }()
    
    let bookimage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        return image
    }()
    
    let titleLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.font = UIFont.italicSystemFont(ofSize: 17)
        Label.adjustsFontSizeToFitWidth = true
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
        
        self.contentView.addSubview(reviewLabel)
        self.contentView.addSubview(bookimage)
        self.contentView.addSubview(titleLabel)
        
        bookimage.translatesAutoresizingMaskIntoConstraints = false
        bookimage.topAnchor.constraint(equalTo:contentView.topAnchor, constant: viewHeight10 * 2).isActive = true
        bookimage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: viewWidth22 * 2).isActive = true
        bookimage.widthAnchor.constraint(equalToConstant: viewWidth22 * 8).isActive = true
        bookimage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewHeight10 * 2).isActive = true
       // bookimage.heightAnchor.constraint(equalToConstant: viewHeight10 * 10).isActive = true
        
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.topAnchor.constraint(equalTo:bookimage.topAnchor).isActive = true
        reviewLabel.leadingAnchor.constraint(equalTo: bookimage.trailingAnchor,constant: viewWidth22 * 2).isActive = true
        reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -viewWidth22 * 2).isActive = true
        reviewLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo:reviewLabel.bottomAnchor, constant: viewHeight10 * 3).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookimage.trailingAnchor,constant: viewWidth22 * 3.5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -viewWidth22 * 3.5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -viewHeight10 * 2).isActive = true
        
        
    }
}




