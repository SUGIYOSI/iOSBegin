//
//  PearsonViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/20.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class PearsonViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource {

    var Bookers = [BookData]()
    var myBookers = [BookData]()
    var savebook = BookData()
    var Book = BookData()
    var user = User()
    var tapuser = User()
    var IMAGE = UIImage()
    private var tableview: UITableView!
    
    let SafeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1) 
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        user = NowUser.shared.nowuser
        Book = NowUser.shared.nowbook
        
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        for book in Bookers {
            for (key,value) in book.BookViews{
                if value == tapuser.UserID{
                    savebook = book
                    savebook.BookViews.removeAll()
                    savebook.BookViews.updateValue(value, forKey: key)
                    myBookers.append(book)
                }
            }
        }
        
        //テーブルビューの初期化
        tableview = UITableView()
        //デリゲートの設定
        tableview.delegate = self
        tableview.dataSource = self
        tableview.contentOffset = CGPoint(x: 0,y :44)
        tableview.rowHeight = 100
        //ナビゲーションバーの設定
        let myNavBar = UINavigationBar()
        //大きさの指定
        myNavBar.isTranslucent = false
        myNavBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        myNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        
        let myNavItems = UINavigationItem()
        myNavItems.title = tapuser.UserID
        
        if tapuser.UserImage == nil {
            IMAGE = UIImage(named: "NoImage")!.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }else{
            IMAGE = (UIImage(data: tapuser.UserImage! as Data)?.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))!
        }
        
        let button = UIButton(type: .system)
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(IMAGE ,  for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        let rightNavBtn = UIBarButtonItem(customView: button)
        myNavItems.leftBarButtonItem = rightNavBtn
        myNavItems.rightBarButtonItem = rightNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        let leftNavBtn = UIBarButtonItem(barButtonHiddenItem: .Back, target: nil, action: #selector(leftBarBtnClicked(sender:)))
        leftNavBtn.action = #selector(leftBarBtnClicked(sender:))
        myNavItems.leftBarButtonItem = leftNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        //テーブルビューの大きさの指定
        tableview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + myNavBar.frame.height, width: viewWidth, height: viewHeight - UIApplication.shared.statusBarFrame.height - myNavBar.frame.height)
        tableview.register(PearsonCustomCell.self, forCellReuseIdentifier: "PearsonCustomCell")
        self.view.addSubview(tableview)
        
        self.view.addSubview(SafeView)
        SafeView.translatesAutoresizingMaskIntoConstraints = false
        SafeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SafeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        SafeView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
    }
    
    @objc internal func leftBarBtnClicked(sender: UIButton){
        NowUser.shared.nowbook = Book
        navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセルの数はSearchResult配列の数とした
        return myBookers.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SearchResult配列の中身をテキストにして登録した
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "PearsonCustomCell",for: indexPath as IndexPath) as! PearsonCustomCell
        var KEY: String = String()
        var IMAGE: UIImage?
        var TITLE: String = String()
        
        for(key,value) in myBookers[indexPath.row].BookViews {
            if value == tapuser.UserID {
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
            cell.bookimage.image = UIImage(named: "NoImage")?.resize(size: CGSize(width: 50, height: 50))
        }
        
        cell.titleLabel.text = TITLE
        cell.layoutIfNeeded()
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        // 画質を落とさないように以下を修正
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
}
}


class PearsonCustomCell: UITableViewCell {
    
    let reviewLabel:UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.layer.cornerRadius = 0
        textview.layer.masksToBounds = true
        return textview
    }()
    
    let bookimage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        return image
    }()
    
    let titleLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
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







