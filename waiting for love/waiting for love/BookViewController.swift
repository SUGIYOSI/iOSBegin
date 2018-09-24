//
//  nextViewController.swift
//  waiting for love
//
//  Created by 杉山佳史 on 2018/09/11.
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
    
    //UIImageViewのインスタンスを宣言（viewImage）
    let viewImage: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x:105 ,y:80, width:164, height:100)
        image.backgroundColor = .gray
        return image
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //シリアライズ処理（Bookers）
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        //viewの大きさを取得
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        //Viewの中に２つのViewを宣言する
 
        //viewその１（上画面）
        let view1: UIView = {
            let view1 = UIView()
            view1.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight / 2)
            view1.backgroundColor = .white
            
            let nextNavBar = UINavigationBar()
            nextNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
            
            let nextNavItems = UINavigationItem()
            nextNavItems.title = "本の紹介"
            let rightNavBtn =  UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(rightBtnClicked(sender:)))
            nextNavItems.leftBarButtonItem = rightNavBtn
            rightNavBtn.action = #selector(rightBtnClicked(sender:))
            nextNavItems.rightBarButtonItem = rightNavBtn;
            nextNavBar.pushItem(nextNavItems, animated: true)
            view1.addSubview(nextNavBar)
            
            
            let leftNavBtn =  UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(leftBtnClicked(sender:)))
            leftNavBtn.action = #selector(leftBtnClicked(sender:))
            nextNavItems.leftBarButtonItem = leftNavBtn;
            nextNavBar.pushItem(nextNavItems, animated: true)
            view1.addSubview(nextNavBar)
            
            
            let label = UILabel()
            label.frame = CGRect(x:99, y:201, width:177, height:36)
            label.text = Books.BookTitle
            view1.addSubview(label)
            
            
            let label2 = UILabel()
            label2.frame = CGRect(x:99, y:258, width:177, height:36)
            label2.text = Books.Author
            view1.addSubview(label2)
            
            
            
            if Books.BookImage == nil {
             }else{
                let IMAGE: UIImage? = UIImage(data: Books.BookImage! as Data)
                viewImage.image = IMAGE
            }
            view1.addSubview(viewImage)
            
            
            
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
            //デリゲートの設定
            TableView.delegate = self
            TableView.dataSource = self
            //テーブルビューの大きさの指定
            TableView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: view2height )
            //テーブルビューの設置
            TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            view2.addSubview(TableView)
            
            return view2
        }()
        
        self.view.addSubview(view2)
        
    }
    
    
    ////MARK: - ナビゲーションバーの右のボタンが押されたら呼ばれるメソッド
    @objc internal func rightBtnClicked(sender: UIButton){
        //Post画面に進む
        let vc = PostViewController()
        vc.Book = Books
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK: - ナビゲーションバーの左のボタンが押されたら呼ばれるメソッド
    @objc internal func leftBtnClicked(sender: UIButton){
        //Search画面に戻る
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //テーブルビューのデリゲードメソッドたち
    
    
      //MARK: テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Books.BookView.count
    }
    
     //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = Books.BookView[indexPath.row]
        return cell
        
    }
    
    //MARK: テーブルビューのセルを削除する処理
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //削除可能かどうか
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            //Todoリストから削除
            Books.BookView.remove(at: indexPath.row)
            //セルを削除
            TableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            for book in Bookers {
                if book.BookTitle == Books.BookTitle {
                    book.BookView = Books.BookView
                }
            }
            
            //シリアライズ処理（Bookers）
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "Bookers")
            userDefaults.synchronize()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

