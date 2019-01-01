import UIKit

class SearchViewController: UIViewController,UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource ,UISearchResultsUpdating {
    
    var Bookers = [BookData]()
    var Book = BookData()
    var searchResult: Array = Array<String>()
    var myItems     : Array = Array<String>()
    var tableView: UITableView!
    var searchController: UISearchController!
    
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
        let viewHeight = self.view.frame.size.height
        
        //NavigationBarとsearchBar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        //searchBarはsearchControllerからアクセスできることを示している一文
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 1)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    
        self.navigationItem.title = "本検索"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        
        //TableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCustomCell.self, forCellReuseIdentifier: "SearchCustomCell")
        tableView.rowHeight = viewHeight / 9
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: viewHeight - UIApplication.shared.statusBarFrame.height - (navigationController?.navigationBar.frame.height)!).isActive = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
        let text = searchController.searchBar.text ?? ""
        if text.isEmpty {
            searchResult = myItems
        } else {
            searchResult = myItems.filter { $0.contains(text) }
        }
        tableView.reloadData()
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
    
    
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        //削除可能かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //Bookersの各BookTitleを参照し、searchResult[indexPath.row]から該当するBookを削除する。
            for book in Bookers {
                if let title = book.BookTitle {
                    if title == searchResult[indexPath.row] {
                        if let BookersIndex = Bookers.index(of: book) {
                            let index: Int = BookersIndex
                            Bookers.remove(at: index)
                        }
                    }
                }
            }
            //searchResultも削除
            searchResult.remove(at: indexPath.row)
            //セルを削除
            tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //デシリアライズ処理（Bookers）
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "Bookers")
            userDefaults.synchronize()
            tableview.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //全ての値を初期化する
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
