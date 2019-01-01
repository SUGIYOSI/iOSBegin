import UIKit

class HomeViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    var Bookers = [BookData]()
    var myBookers = [BookData]()
    var user = User()
    var userImage = UIImage()
    var tableView: UITableView!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginCheck()
        resetValue()
        serialize()
        //Bookersの中から、自分の投稿したBookだけを取り出し、myBookrsに入れる
        for book in Bookers {
            for (_,value) in book.BookViews{
                if value == user.UserID{
                    myBookers.append(book)
                }
            }
        }
        setNavigationBar()
        navigationController?.navigationBar.setNeedsLayout()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBookers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCustomCell",for: indexPath as IndexPath) as! HomeCustomCell
        //myBookの中の全てのレビューの中から自分のレビューを探し代入する
        cell.setCell(indexPath: indexPath.row , myBookers: myBookers , user: user)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NowUser.shared.nowbook = myBookers[indexPath.row]
        let vc = BookViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginCheck(){
        if NowUser.shared.nowuser.UserID == nil {
            let nc = UINavigationController(rootViewController: LoginViewController())
            self.present(nc, animated: true, completion: nil)
            return
        }
    }
    
    //全ての値を初期化する
    func resetValue(){
        user = NowUser.shared.nowuser
        myBookers.removeAll()
        Bookers.removeAll()
    }
    
    //シリアライズ
    func serialize() {
        Bookers.removeAll()
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
    }
    
    func setNavigationBar(){
        //左の画像の設定
        let leftUserImageView: UIImageView = {
            //一番最初に画面を開いた時、userImageにnilが入ってエラーが出るのを防ぐため
            if NowUser.shared.nowuser.UserID != nil {
                if let unwrapedUserImage = user.UserImage{
                     userImage = (UIImage(data: unwrapedUserImage as Data)?.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImage.RenderingMode.alwaysOriginal))!
                }
            }
            //ここでやっと初期化
            let imageView = UIImageView(image: userImage)
            imageView.layer.cornerRadius = 6
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        self.navigationItem.title = user.UserID
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        let leftUserImageButton: UIBarButtonItem = UIBarButtonItem(customView: leftUserImageView)
        self.navigationItem.leftBarButtonItem = leftUserImageButton
    }
    
    func setTableView(){
        let viewHeight = self.view.frame.size.height
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = viewHeight / 7
        tableView.register(HomeCustomCell.self, forCellReuseIdentifier: "HomeCustomCell")
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: viewHeight - UIApplication.shared.statusBarFrame.height - (navigationController?.navigationBar.frame.height)!).isActive = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // インスタンスが生成されたときに動く関数
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let viewHeight10 = self.contentView.frame.height / 10
        let viewWidth22 = self.contentView.frame.width / 22
        
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
    
    
    func setCell(indexPath: Int, myBookers: [BookData],user: User){
    //myBookの中の全てのレビューの中から自分のレビューを探し代入する
        for(key,value) in myBookers[indexPath].BookViews {
            if value == user.UserID {
                reviewLabel.text = key
                if let unwrapedBookImage = myBookers[indexPath].BookImage{
                    bookimage.image = (UIImage(data: unwrapedBookImage as Data))?.resize(size: CGSize(width: 50, height: 50))
                }
                titleLabel.text = myBookers[indexPath].BookTitle
            }
        }
    }
}
