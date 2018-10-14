//
//  BookViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/19.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //TableViewインスタンス
    private var TableView: UITableView!
    //BookData型の配列,Bookersを宣言
    var Bookers = [BookData]()
    //BookData型のObjectを宣言
    var Books   = BookData()
    var users = [User]()
    var user  = User()
    var tapuser = User()
    var ifID = String()
    var StockKeys: [String] = Array()
    var StockValues: [String] = Array()
    
    let SafeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        user = NowUser.shared.nowuser
        Books = NowUser.shared.nowbook
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //シリアライズ処理
        let userdefaults = UserDefaults.standard
        if let storedusers = userdefaults.object(forKey: "users") as? Data {
            if let unarchiveusers = NSKeyedUnarchiver.unarchiveObject(with: storedusers) as? [User] {
                users.append(contentsOf: unarchiveusers)
            }
        }
        
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        StockKeys = Array(Books.BookViews.keys)
        StockValues = Array(Books.BookViews.values)
        
        //viewの大きさを取得
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        let view8Width = self.view.frame.size.width / 8
        let view8Height = self.view.frame.size.height / 8
//        let view16Width = self.view.frame.size.width / 16
//        let view16Height = self.view.frame.size.height / 16
        let view22Height = self.view.frame.size.height / 22
        
        //Viewの中に２つのViewを宣言する
        
        //viewその１（上画面）
        let view1: UIView = {
            let view1 = UIView()
            view1.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight / 2)
            view1.backgroundColor = .white
            
            let nextNavBar = UINavigationBar()
            nextNavBar.isTranslucent = false
            nextNavBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1) 
            nextNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
            
            let nextNavItems = UINavigationItem()
            nextNavItems.title = "本の紹介"
            let rightNavBtn =  UIBarButtonItem()
            nextNavItems.leftBarButtonItem = rightNavBtn
            nextNavItems.rightBarButtonItem = rightNavBtn;
            nextNavBar.pushItem(nextNavItems, animated: true)
            view1.addSubview(nextNavBar)
            
            let leftNavBtn: UIBarButtonItem = UIBarButtonItem(barButtonHiddenItem: .Back, target: nil, action: #selector(leftBtnClicked(sender:)))
            leftNavBtn.action = #selector(leftBtnClicked(sender:))
            nextNavItems.leftBarButtonItem = leftNavBtn;
            nextNavBar.pushItem(nextNavItems, animated: true)
            view1.addSubview(nextNavBar)
            
            let booktitle: UILabel = {
                let label = UILabel()
                label.text = Books.BookTitle
                if label.text == nil {
                    label.text = "入力してください"
                    label.shadowColor = UIColor.gray
                }
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = NSTextAlignment.center
                return label
            }()
            
            let bookauthor: UILabel = {
                let label = UILabel()
                label.text = Books.Author
                if label.text == nil {
                    label.text = "入力してください"
                    label.shadowColor = UIColor.black
                    label.font = UIFont.italicSystemFont(ofSize: 17)
                }
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = NSTextAlignment.center
                return label
            }()
            
            let booktitlename: UILabel = {
                let label = UILabel()
                label.text = "作品名"
                label.font = UIFont.italicSystemFont(ofSize: 17)
                label.adjustsFontSizeToFitWidth = true
                return label
            }()
            
            let bookauthorname: UILabel = {
                let label = UILabel()
                label.text = "作者"
                label.font = UIFont.italicSystemFont(ofSize: 17)
                label.adjustsFontSizeToFitWidth = true
                return label
            }()
            
            let viewImage: UIImageView = {
                let image = UIImageView()
                image.backgroundColor = UIColor(white: 0.9, alpha: 1)
                image.layer.cornerRadius = 30
                image.layer.masksToBounds = true
                return image
            }()
            
            if Books.BookImage == nil {
                viewImage.image = UIImage(named: "NoImage")
            }else{
                let IMAGE: UIImage? = UIImage(data: Books.BookImage! as Data)
                viewImage.image = IMAGE
            }
            
            view1.addSubview(booktitle)
            view1.addSubview(bookauthor)
            view1.addSubview(booktitlename)
            view1.addSubview(bookauthorname)
            view1.addSubview(viewImage)
            
            viewImage.translatesAutoresizingMaskIntoConstraints = false
            viewImage.topAnchor.constraint(equalTo: view1.topAnchor, constant: view8Height * 1.1).isActive = true
            viewImage.widthAnchor.constraint(equalToConstant: view8Width * 4).isActive = true
            viewImage.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
            viewImage.heightAnchor.constraint(equalToConstant: view22Height * 3).isActive = true
            
            booktitle.translatesAutoresizingMaskIntoConstraints = false
            booktitle.topAnchor.constraint(equalTo: viewImage.bottomAnchor, constant: view22Height * 1.5).isActive = true
            booktitle.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
            booktitle.widthAnchor.constraint(equalToConstant: view8Width * 4).isActive = true
            booktitle.heightAnchor.constraint(equalToConstant: view22Height).isActive = true
            
            bookauthor.translatesAutoresizingMaskIntoConstraints = false
            bookauthor.topAnchor.constraint(equalTo: booktitle.bottomAnchor, constant: view22Height).isActive = true
            bookauthor.widthAnchor.constraint(equalToConstant: view8Width * 4).isActive = true
            bookauthor.heightAnchor.constraint(equalTo: booktitle.heightAnchor).isActive = true
            bookauthor.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
            
            booktitlename.translatesAutoresizingMaskIntoConstraints = false
            booktitlename.topAnchor.constraint(equalTo: booktitle.topAnchor).isActive = true
            booktitlename.widthAnchor.constraint(equalToConstant: view8Width * 1.5).isActive = true
            booktitlename.heightAnchor.constraint(equalTo: booktitle.heightAnchor).isActive = true
            booktitlename.leadingAnchor.constraint(equalTo: view1.leadingAnchor, constant: view8Width / 2).isActive = true
            
            bookauthorname.translatesAutoresizingMaskIntoConstraints = false
            bookauthorname.topAnchor.constraint(equalTo: bookauthor.topAnchor).isActive = true
            bookauthorname.widthAnchor.constraint(equalToConstant: view8Width).isActive = true
            bookauthorname.heightAnchor.constraint(equalTo: bookauthor.heightAnchor).isActive = true
            bookauthorname.leadingAnchor.constraint(equalTo: view1.leadingAnchor, constant: view8Width / 2).isActive = true
            
            return view1
        }()
        
        self.view.addSubview(view1)
        
        //viewその２（下画面）
        let view2: UIView = {
            let view2 = UIView()
            view2.frame = CGRect(x: 0, y: viewHeight / 2, width: viewWidth, height: viewHeight / 2)
            let view2height = view2.frame.size.height
            view2.backgroundColor = .white
            
            
            TableView = UITableView()
            self.TableView.rowHeight = 90
            //デリゲートの設定
            TableView.delegate = self
            TableView.dataSource = self
            //テーブルビューの大きさの指定
            TableView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: view2height )
            //テーブルビューの設置
            TableView.register(BookCustomCell.self, forCellReuseIdentifier: "BookCustomCell")
            
            
            view2.addSubview(TableView)
            
            return view2
        }()
        
        self.view.addSubview(view2)
        self.view.addSubview(SafeView)
        
        SafeView.translatesAutoresizingMaskIntoConstraints = false
        SafeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SafeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        SafeView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
    }
    
    //MARK: - ナビゲーションバーの左のボタンが押されたら呼ばれるメソッド
    @objc internal func leftBtnClicked(sender: UIButton){
        //Search画面に戻る
        NowUser.shared.nowbook = Books
        navigationController?.popViewController(animated: true)
    }
    
    
    //テーブルビューのデリゲードメソッドたち
    //MARK: テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Books.BookViews.keys.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCustomCell",for: indexPath as IndexPath) as! BookCustomCell
        
        cell.reviewLabel.text = StockKeys[indexPath.row]
        
        for use in users {
            if use.UserID == StockValues[indexPath.row] {
                if use.UserImage == nil{
                cell.userimage.image = UIImage(named: "NoImage")?.resize(size: CGSize(width: 50, height: 50))
                } else {
                cell.userimage.image = UIImage(data: use.UserImage! as Data)?.resize(size: CGSize(width: 50, height: 50))
                }
            }
        }
    
        return cell
    }
    
    //MARK: テーブルビューのセルを削除する処理
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //削除可能かどうか
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let key: String = StockKeys[indexPath.row]
            StockKeys.remove(at: indexPath.row)
            Books.BookViews.removeValue(forKey: key)
            TableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            for book in Bookers {
                if book.BookTitle == Books.BookTitle {
                    book.BookViews = Books.BookViews
                }
            }
            //シリアライズ処理（Bookers）
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "Bookers")
            userDefaults.synchronize()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for book in Bookers {
            for (key,value) in book.BookViews{
                if key ==  StockKeys[indexPath.row]{
                    ifID = value
                }
            }
        }
        
        for USE in users{
            if USE.UserID == ifID {
                tapuser = USE
            }
        }
        
        //上の処理で持ってきた、BookData型のBookaを次の画面へ持っていく
        let vc = PearsonViewController()
        vc.tapuser = tapuser
        NowUser.shared.nowbook = Books
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




extension UIBarButtonItem {
    enum HiddenItem: Int {
        case Arrow = 100
        case Back = 101
        case Forward = 102
        case Up = 103
        case Down = 104
    }
    
    convenience init(barButtonHiddenItem: HiddenItem, target: AnyObject?, action: Selector?) {
        let systemItem = UIBarButtonSystemItem(rawValue: barButtonHiddenItem.rawValue)
        self.init(barButtonSystemItem: systemItem!, target: target, action: action)
    }
}


class BookCustomCell: UITableViewCell {
    
    let reviewLabel:UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.layer.cornerRadius = 0
        textview.layer.masksToBounds = true
        return textview
    }()
    
    let userimage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        return image
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
        self.contentView.addSubview(userimage)
        
        
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: viewHeight10 * 1).isActive = true
        reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: viewWidth22 * 1).isActive = true
        reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ,constant: -viewWidth22 * 10).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewHeight10 * 1).isActive = true
       // reviewLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        userimage.translatesAutoresizingMaskIntoConstraints = false
        userimage.topAnchor.constraint(equalTo:contentView.topAnchor, constant: viewHeight10 * 4).isActive = true
        userimage.leadingAnchor.constraint(equalTo: reviewLabel.trailingAnchor,constant: viewWidth22 * 2).isActive = true
        userimage.widthAnchor.constraint(equalToConstant: viewWidth22 * 6).isActive = true
        userimage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewHeight10 * 4).isActive = true
        
     
        
        
    }
}




