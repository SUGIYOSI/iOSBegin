import UIKit

class BookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var Bookers = [BookData]()
    var Book   = BookData()
    var users = [User]()
    var tapuser = User()
    //Keyは本のレビュー,Valueはレビューを投稿した人のUserID。
    var StockKeys: [String] = Array()
    var StockValues: [String] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Book = NowUser.shared.nowbook
        StockKeys = Array(Book.BookViews.keys)
        StockValues = Array(Book.BookViews.values)
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
        
        //viewの大きさを取得
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        let view8Width = self.view.frame.size.width / 8
        let view8Height = self.view.frame.size.height / 8
        let view22Height = self.view.frame.size.height / 22
        
        //Viewの中に２つのViewを宣言する
        //viewその１（上画面）
        let view1: UIView = {
            let view1 = UIView()
            //AutoLayout出来ないのでCGRect使います！
            view1.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight / 2)
            view1.backgroundColor = .white
            
            //NavigationBar
            self.navigationItem.title = "本の紹介"
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
            let leftBackButton = UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(leftBackButtonClick(sender:)))
            self.navigationItem.leftBarButtonItem = leftBackButton
            
            //UI部品
            let booktitle: UILabel = {
                let label = UILabel()
                label.text = Book.BookTitle
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
                label.text = Book.Author
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
            
            if let unwrapedBookImage = Book.BookImage{
                viewImage.image  = UIImage(data: unwrapedBookImage as Data)
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
        
        //viewその２（下画面）
        let view2: UIView = {
            let view2 = UIView()
            //AutoLayout出来ないのでCGRect使います！
            view2.frame = CGRect(x: 0, y: viewHeight / 2, width: viewWidth, height: viewHeight / 2)

            //TableView
            tableView = UITableView()
            tableView.rowHeight = viewHeight / 7
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(BookCustomCell.self, forCellReuseIdentifier: "BookCustomCell")
            view2.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view2.topAnchor).isActive = true
            tableView.widthAnchor.constraint(equalTo: view2.widthAnchor).isActive = true
            tableView.centerXAnchor.constraint(equalTo: view2.centerXAnchor).isActive = true
            tableView.heightAnchor.constraint(equalTo: view2.heightAnchor).isActive = true
            return view2
        }()
        
        self.view.addSubview(view1)
        self.view.addSubview(view2)
    }
    
    @objc func leftBackButtonClick(sender: UIButton){
        NowUser.shared.nowbook = Book
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Book.BookViews.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCustomCell",for: indexPath as IndexPath) as! BookCustomCell
        cell.setCell(indexPath: indexPath.row, users: users, StockValues: StockValues ,StockKeys:  StockKeys)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //投稿したユーザーを探し,tapUserに入れる。
        for searchUser in users{
            if searchUser.UserID == StockValues[indexPath.row] {
                tapuser = searchUser
            }
        }

        let vc = PearsonViewController()
        vc.tapUser = tapuser
        NowUser.shared.nowbook = Book
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        //削除可能かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            //それぞれ削除する
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            StockKeys.remove(at: indexPath.row)
            Book.BookViews.removeValue(forKey: StockKeys[indexPath.row])
            
            //削除したところをBookersに反映させる
            for book in Bookers {
                if book.BookTitle == Book.BookTitle {
                    book.BookViews = Book.BookViews
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

//TableViewCell
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 引数のないコンストラクタみたいなもの。
    // インスタンスが生成されたときに動く関数
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let viewHeight10 = self.contentView.frame.height / 10
        let viewWidth22 = self.contentView.frame.width / 22
        
        self.contentView.addSubview(reviewLabel)
        self.contentView.addSubview(userimage)
        
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: viewHeight10 * 1).isActive = true
        reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: viewWidth22 * 1).isActive = true
        reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ,constant: -viewWidth22 * 10).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewHeight10 * 1).isActive = true
        
        userimage.translatesAutoresizingMaskIntoConstraints = false
        userimage.topAnchor.constraint(equalTo:contentView.topAnchor, constant: viewHeight10 * 4).isActive = true
        userimage.leadingAnchor.constraint(equalTo: reviewLabel.trailingAnchor,constant: viewWidth22 * 2).isActive = true
        userimage.widthAnchor.constraint(equalToConstant: viewWidth22 * 6).isActive = true
        userimage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewHeight10 * 4).isActive = true
        
    }
    
    func setCell(indexPath: Int, users: [User], StockValues: [String], StockKeys: [String]){
        for use in users {
            if use.UserID == StockValues[indexPath] {
                if let unwrapedUserImage = use.UserImage{
                    userimage.image = UIImage(data: unwrapedUserImage as Data)?.resize(size: CGSize(width: 50, height: 50))
                }
            }
        }
        reviewLabel.text = StockKeys[indexPath]
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
        let systemItem = UIBarButtonItem.SystemItem(rawValue: barButtonHiddenItem.rawValue)
        self.init(barButtonSystemItem: systemItem!, target: target, action: action)
    }
}
