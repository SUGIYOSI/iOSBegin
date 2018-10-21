import UIKit

class PearsonViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource {

    var Bookers = [BookData]()
    var myBookers = [BookData]()
    var Book = BookData()
    var user = User()
    var tapUser = User()
    var tapUserImage = UIImage()
    var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        user = NowUser.shared.nowuser
        Book = NowUser.shared.nowbook
        //Bookersの中から、そのユーザーの投稿したBookだけを取り出し、myBookrsに入れる
        for book in Bookers {
            for (_,value) in book.BookViews{
                if value == tapUser.UserID{
                    myBookers.append(book)
                }
            }
        }
        
        //NavigationBar
        let rightTapUserImageView: UIImageView = {
            tapUserImage = (UIImage(data: tapUser.UserImage! as Data)?.resize(size: CGSize(width: 50, height: 50)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))!
         
            let imageView = UIImageView(image: tapUserImage)
            imageView.layer.cornerRadius = 6
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        self.title = tapUser.UserID
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        let rightUserImageButton = UIBarButtonItem(customView: rightTapUserImageView)
        let leftBackButton = UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(leftBackButtonClick(sender:)))
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationItem.rightBarButtonItem = rightUserImageButton
        
        //TableView
        tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.contentOffset = CGPoint(x: 0,y :44)
        tableview.rowHeight = 100
        tableview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!, width: viewWidth, height: viewHeight - UIApplication.shared.statusBarFrame.height - (navigationController?.navigationBar.frame.height)!)
        tableview.register(PearsonCustomCell.self, forCellReuseIdentifier: "PearsonCustomCell")
        self.view.addSubview(tableview)
        
    }
    
    @objc internal func leftBackButtonClick(sender: UIButton){
        NowUser.shared.nowbook = Book
        navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBookers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PearsonCustomCell",for: indexPath as IndexPath) as! PearsonCustomCell
        cell.setCell(indexPath: indexPath.row, myBookers: myBookers, tapUser:  tapUser)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 引数のないコンストラクタみたいなもの。
    // インスタンスが生成されたときに動く関数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    func setCell(indexPath: Int, myBookers: [BookData], tapUser: User){
        for(key,value) in myBookers[indexPath].BookViews {
            if value == tapUser.UserID {
                reviewLabel.text = key
                bookimage.image = UIImage(data: myBookers[indexPath].BookImage! as Data)
                titleLabel.text = myBookers[indexPath].BookTitle!
            }
        }
    }
}

extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
