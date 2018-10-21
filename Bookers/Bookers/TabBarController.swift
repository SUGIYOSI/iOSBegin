import UIKit

class TabBarController: UITabBarController{
    
    enum ViewControllers {
        case home
        case search
        case post
        case setting
    }
    
    var searchview: SearchViewController!
    var homeview: HomeViewController!
    var postview: PostViewController!
    var setting: SettingViewController!
    let vcArray: [ViewControllers] = [.home,.search,.post,.setting]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myTabs: [UIViewController] = []
        
        for (i, vc) in vcArray.enumerated() {
            var tabVC: UIViewController!
            switch vc {
            case .home:
                tabVC = HomeViewController()
                tabVC.tabBarItem.image = UIImage(named: "home")?.resize(size: CGSize(width: 30, height: 30))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Home"
            case .search:
                tabVC = SearchViewController()
                tabVC.tabBarItem.image = UIImage(named: "search")?.resize(size: CGSize(width: 30, height: 30))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Search"
            case .post:
                tabVC = PostViewController()
                tabVC.tabBarItem.image = UIImage(named: "post")?.resize(size: CGSize(width: 40, height: 40))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Post"
            case .setting:
                tabVC = SettingViewController()
                tabVC.tabBarItem.image = UIImage(named: "setting")?.resize(size: CGSize(width: 30, height: 30))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Setting"
            }
            let nc = UINavigationController(rootViewController: tabVC)
            myTabs.append(nc)
        }
        self.setViewControllers(myTabs, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}


