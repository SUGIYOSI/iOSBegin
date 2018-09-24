//
//  changeViewController.swift
//  waiting for love
//
//  Created by 杉山佳史 on 2018/09/11.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit


class PostViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate{
     //BookData型の配列,Bookersを宣言
    var Bookers = [BookData]()
    ////BookData型のObjectを宣言
    var Book = BookData()
    
    
    let textbar1: UITextField = {
        let textbar = UITextField()
        textbar.frame = CGRect(x: 95, y: 282, width: 168, height: 30)
        textbar.backgroundColor = .gray
        return textbar
    }()
    
    let textbar2: UITextField = {
        let textbar = UITextField()
         textbar.frame = CGRect(x: 95, y: 353, width: 168, height: 30)
        textbar.backgroundColor = .gray
        return textbar
    }()
    
    let textview: UITextView = {
        let textview = UITextView()
        textview.frame = CGRect(x: 67, y: 96, width: 240, height: 128)
        textview.backgroundColor = .gray
        return textview
    }()
    
    let importImage: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: 82, y: 428, width: 210, height: 145)
        image.backgroundColor = .gray
        return image
    }()
    
    let saveButton: UIButton = {
        let save = UIButton()
        save.backgroundColor = .blue
        save.frame = CGRect(x: 144, y: 645, width: 87, height: 33)
        save.setTitle("画像をお願いします", for: UIControlState.normal)
        save.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControlEvents.touchUpInside)
        return save

    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //シリアライズ 処理（Bookers）
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        //Viewの大きさを取得
        let viewWidth = self.view.frame.size.width
       // let viewHeight = self.view.frame.size.height
        
        //NavigationBar関連
        //UINavigationBarを作成
        let myNavBar = UINavigationBar()
        //大きさの指定
        myNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        //タイトル、虫眼鏡ボタンの作成
        let myNavItems = UINavigationItem()
        myNavItems.title = "感想を教えて下さい"
        let rightNavBtn =  UIBarButtonItem(barButtonSystemItem:  .undo, target: self, action: #selector(rightBarBtnClicked(sender:)))
        myNavItems.leftBarButtonItem = rightNavBtn
        rightNavBtn.action = #selector(rightBarBtnClicked(sender:))
        myNavItems.rightBarButtonItem = rightNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        let leftNavBtn =  UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(leftBarBtnClicked(sender:)))
        leftNavBtn.action = #selector(leftBarBtnClicked(sender:))
        myNavItems.leftBarButtonItem = leftNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        textbar1.text = Book.BookTitle
        textbar2.text = Book.Author
        self.view.addSubview(textbar1)
        self.view.addSubview(textbar2)
        self.view.addSubview(textview)
        if Book.BookImage == nil {
        }else{
            let IMAGE: UIImage? = UIImage(data: Book.BookImage! as Data)
            importImage.image = IMAGE
        }
        self.view.addSubview(importImage)
        self.view.addSubview(saveButton)
        

        // Do any additional setup after loading the view.
    }
    
    
    
    @objc internal func rightBarBtnClicked(sender: UIButton){
        
        Book.BookTitle = textbar1.text
        Book.Author    = textbar2.text
        Book.BookView.append(textview.text)
        
        
        for book in Bookers {
            if book.BookTitle == Book.BookTitle {
                    book.BookTitle = Book.BookTitle
                    book.Author    = Book.Author
                    book.BookView  = Book.BookView
                    book.BookImage = Book.BookImage
            }
        }
            
        
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "Bookers")
        userDefaults.synchronize()
        
        let vc = BookViewController()
        vc.Books = Book
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func buttonEvent(_ sender: UIButton) {
        let image = UIImagePickerController()
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
            
        }
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            importImage.image = image
            let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
            Book.BookImage = imageData
            
        }
        else
        {
            //ErrorMesseage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @objc internal func leftBarBtnClicked(sender: UIButton){
        
        let vc = BookViewController()
        vc.Books = Book
        
        navigationController?.pushViewController(vc, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
