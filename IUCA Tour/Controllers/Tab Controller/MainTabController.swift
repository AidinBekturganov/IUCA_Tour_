//
//  MainTabController.swift
//  IUCA Tour
//
//  Created by User on 1/3/22.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    let userDefaults = UserDefaults.standard
    
    var language: String = ""
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(actionButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private let loadingIndicator: ProgressView = {
        let progressView = ProgressView(colors: [.iucaBlue], lineWidth: 3)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        configureIndicator()
        language = userDefaults.object(forKey: "Language") as? String ?? ""
        
        let _ = checkIfLanguageIsSelected(lang: language)
        
        self.selectedIndex = 1

        if #available(iOS 13.0, *) {
           let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithDefaultBackground()
           if #available(iOS 15.0, *) {
              UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
           }
        }
        
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTaped() {
        print("123")
    }
    
    //MARK: - Helpers
    
    func checkIfLanguageIsSelected(lang: String) -> Bool {
        if lang != "" {
            userDefaults.setValue(lang, forKey: "Language")
        }
        
        let value = userDefaults.object(forKey: "Language") as? String ?? ""
        
        if value == "" {
            
            DispatchQueue.main.async {
                
                let controller = SelectLanguageController()
                
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            fetchPlaces { places in
                DispatchQueue.main.async {
                    self.loadingIndicator.isAnimating = false

                    self.configureViewController(lan: value, places: places)
                }
                
            }
            return true
        }
        return false
        
    }
    
    private func fetchPlaces(completion: @escaping([Place]) -> Void) {

        ApiService.shared.fetchPlacesOfTour(language: language) { places in
            completion(places)
        }
    }
    
    private func configureIndicator() {
        view.backgroundColor = .white
        
        view.addSubview(loadingIndicator)
        loadingIndicator.setDimensions(width: 50, height: 50)
        loadingIndicator.center(inView: view)
        
        loadingIndicator.isAnimating = true
    }
    
    func configureViewController(lan: String, places: [Place]) {
        
        let about = AboutController(lang: lan, places: places)
        let nav1 = templateNavigationController(image: UIImage(named: "1")?.withTintColor(.black),
                                                title: "О МУЦА", rootViewController: about)
        
        let explore = ExploreController(lang: lan, places: places)
        let nav2 = templateNavigationController(image: UIImage(named: "3")?.withTintColor(.black),
                                                title: "ИЗУЧЕНИЕ", rootViewController: explore)
        
        
        let excursion = ExcursionController(lang: lan, places: places)
        let nav3 = templateNavigationController(image: UIImage(named: "2")?.withTintColor(.black),
                                                title: "ЭКСКУРСИЯ", rootViewController: excursion)
        
        viewControllers = [nav1, nav3, nav2]
        self.selectedIndex = 1

        
    }
    
    
    func templateNavigationController(image: UIImage?, title: String, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = NavigationController(rootViewController: rootViewController)
        
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = image?.withTintColor(.iucaBlue)
        self.tabBar.tintColor = .iucaBlue
       
        
//        nav.tabBarController?.tabBar.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
//                                            right: view.rightAnchor, height: 200)
        
       
        nav.navigationBar.barTintColor = .iucaBlue
        nav.tabBarItem.title = title
        
        
        return nav
        
    }
}


