import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var Bookers = [BookData]()
    var Book = BookData()
    var searchResult: Array = Array<String>()
    var myItems     : Array = Array<String>()
    var searchBar: UISearchBar!
    var tableView: UITableView!
    
    //Search（検索）する時、これの他に効率のいいアルゴリズムを考えられませんでした。
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetValue()
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
        myItems = searchResult
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        //NavigationBar
        self.navigationItem.title = "本検索"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        let rightSearchButton =  UIBarButtonItem(barButtonSystemItem:  .search, target: self, action: #selector(rightBarBtnClicked(sender:)))
        self.navigationItem.rightBarButtonItem = rightSearchButton
        
        //SearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        searchBar.showsCancelButton = true
        searchBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        
        //TableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!, width: viewWidth, height: viewHeight - UIApplication.shared.statusBarFrame.height-(navigationController?.navigationBar.frame.height)!)
        tableView.tableHeaderView = searchBar
        tableView.contentOffset = CGPoint(x: 0,y :44)    //サーチバーの高さだけ初期位置を下げる
        tableView.register(SearchCustomCell.self, forCellReuseIdentifier: "SearchCustomCell")
        tableView.rowHeight = 70
        self.view.addSubview(tableView)
    }
    
    //渡された文字列を含む要素を検索し、テーブルビューを再表示する
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
        tableView.reloadData()
    }
    
    //検索しているとき、テキストが変更される毎に呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems(searchText: searchText)
    }
    
    //検索バーのキャンセルボタンが押されると呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        searchResult = myItems
        tableView.reloadData()
    }
    
    
    //検索バーのSearchボタンが押されると呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        //検索する
        searchItems(searchText: searchBar.text! as String)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCustomCell",for: indexPath as IndexPath) as! SearchCustomCell
        cell.setCell(indexPath: indexPath.row, Bookers: Bookers, searchResult: searchResult)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Bookersの各BookTitleを参照し,searchResult[indexPath.row]から該当するBookを持ってくる。
        for book in Bookers {
            if let title = book.BookTitle {
                if title == searchResult[indexPath.row] {
                    Book = book
                }
            }
        }
        let vc = BookViewController()
        NowUser.shared.nowbook = Book
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //削除可能かどうか
        if editingStyle == UITableViewCellEditingStyle.delete {
            //Bookersの各BookTitleを参照し、searchResult[indexPath.row]から該当するBookを削除する。
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
    
    @objc func rightBarBtnClicked(sender: UIButton){
        tableView.contentOffset = CGPoint(x: 0,y :0)
    }
    
    func resetValue(){
        myItems.removeAll()
        searchResult.removeAll()
        Bookers.removeAll()
        Book = BookData()
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 引数のないコンストラクタみたいなもの。
    // インスタンスが生成されたときに動く関数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let viewHeight10 = self.contentView.frame.height / 10
        let viewWidth22 = self.contentView.frame.width / 22
    
        self.contentView.addSubview(bookimage)
        self.contentView.addSubview(titleLabel)
        
        bookimage.translatesAutoresizingMaskIntoConstraints = false
        bookimage.topAnchor.constraint(equalTo:contentView.topAnchor, constant: viewHeight10 * 2).isActive = true
        bookimage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: viewWidth22 * 2).isActive = true
        bookimage.widthAnchor.constraint(equalToConstant: viewWidth22 * 8).isActive = true
        bookimage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewHeight10 * 2).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo:bookimage.topAnchor, constant: viewHeight10 * 4).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookimage.trailingAnchor,constant: viewWidth22 * 3.5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -viewWidth22 * 3.5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -viewHeight10 * 4).isActive = true
        
    }
    
    func setCell(indexPath: Int, Bookers: [BookData], searchResult: [String]){
        //各本の画像を持ってくる
        for book in Bookers {
            if searchResult[indexPath] == book.BookTitle{
                if let image = book.BookImage {
                    bookimage.image = UIImage(data: image as Data)?.resize(size: CGSize(width: 50, height: 50))
                }
            }
        }
        titleLabel.text = searchResult[indexPath]
    }
    
}
