//
//  ChooseTypeOfTourScreen.swift
//  IUCA Tour
//
//  Created by User on 1/11/22.
//

import UIKit

protocol ChooseTypeOfTourDelegate: AnyObject {
    func choosenLanguage(lang: String)
}

class ChooseTypeOfTourController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: ChooseTypeOfTourDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let personsImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.backgroundColor = .black
        iv.image = #imageLiteral(resourceName: "Time_management--5ec7b89a01d0360014d4e550")
        return iv
    }()
    
    private let chooseDurationOfTourLabel: UILabel = {
        let label = UILabel()
        
        label.text = """
        Выберите
        продолжительность
        экскурсии
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.textColor = .white
        return label
    }()
    
    private let quickExcursionButton: UIButton = {
        let button = Utilities().createButton(withTitle: "Быстрая (10 минут)",
                                              backgroundColor: .white, withImageFont: .iucaBlue)
        
        button.addTarget(self, action: #selector(handleGoToExcursionQuick), for: .touchUpInside)
        
        
        
        return button
    }()
    
    private let longExcursionButton: UIButton = {
        let button = Utilities().createButton(withTitle: "Подробная (30 минут)",
                                              backgroundColor: .white, withImageFont: .iucaBlue)
        
        button.addTarget(self, action: #selector(handleGoToExcursionLong), for: .touchUpInside)
        
        
        
        return button
    }()
    
    private var lang: String
    
    private lazy var cusButton = Utilities().createCustomBarButton(buttonType: lang)
    
    private lazy var backBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Vector-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Selectors
    
    @objc func handleGoToExcursionQuick() {
       
        
        let controller = TourDetailController(lang: self.lang, idOfPreset: 1)
        controller.delegate = self
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
            
        
    }
    
    @objc func handleGoToExcursionLong() {
        let controller = TourDetailController(lang: self.lang, idOfPreset: 2)
        controller.delegate = self
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func handleChooseLanguageEngForBarButton() {
        DispatchQueue.main.async {
            let controller = SelectLanguageController()
            
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            
            
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func handleBackButton() {
        delegate?.choosenLanguage(lang: lang)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Lifecycle
    
    init(lang: String) {
        self.lang = lang
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBarButton()
        Utilities().checkInternetConnection(navigationController: self.navigationController!)
    }
    
    //MARK: - Helpers
    
   
    
    func configureBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cusButton)
        cusButton.addTarget(self, action: #selector(handleChooseLanguageEngForBarButton), for: .touchUpInside)
        
    }
    
    func configureUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        
        
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .iucaBlue
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Экскурсия"
        
        view.addSubview(personsImageView)
        personsImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, width: 382, height: 344)
//
        chooseDurationOfTourLabel.adjustsFontSizeToFitWidth = true
        chooseDurationOfTourLabel.minimumScaleFactor = 0.5
        
        
        let viewCover = Utilities().createViewForBackground(color: .iucaBlue)
        
        view.addSubview(viewCover)
        viewCover.anchor(top: personsImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
//        viewCover.addSubview(chooseDurationOfTourLabel)
//        chooseDurationOfTourLabel.centerX(inView: viewCover, topAnchor: viewCover.top, paddingTop: <#T##CGFloat?#>)
        
        let stack = UIStackView(arrangedSubviews: [quickExcursionButton, longExcursionButton])
        
        

        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        
        let viewOne = UIView()
        viewOne.widthAnchor.constraint(equalToConstant: 19).isActive = true
        let viewTwo = UIView()
        viewTwo.widthAnchor.constraint(equalToConstant: 19).isActive = true
        
  
        
        let stackForButtons = UIStackView(arrangedSubviews: [viewOne, stack, viewTwo])
//        stackForButtons.distribution = .equalCentering

        let stackMain = UIStackView(arrangedSubviews: [UIView(), chooseDurationOfTourLabel, stackForButtons, UIView()])

        stackMain.axis = .vertical
        stackMain.spacing = 20
        stackMain.distribution = .equalCentering

        viewCover.addSubview(stackMain)
        stackMain.addConstraintsToFillView(viewCover)
//        stackMain.anchor(paddingTop: -10)
//        stackMain.anchor(paddingLeft: 19, paddingRight: 19)
//        stackMain.anchor(top: viewCover.topAnchor, left: viewCover.leftAnchor, right: viewCover.rightAnchor,
//                         paddingTop: view.safeAreaLayoutGuide.layoutFrame.height / 10, paddingLeft: 10, paddingRight: 10)
        
        
    }
}



extension ChooseTypeOfTourController: SelectLanguageDelegate {
    func selectLang(lang: String) {
        dismiss(animated: true) {
            Utilities().saveLangToTheMemory(lang: lang)
            self.lang = lang
            self.cusButton = Utilities().createCustomBarButton(buttonType: lang)
            self.configureBarButton()
        }
        
    }
}

extension ChooseTypeOfTourController: TourDetailControlleDelegate {
    func choosenLanguage(lang: String) {
        self.lang = lang
        self.cusButton = Utilities().createCustomBarButton(buttonType: lang)
        self.configureBarButton()
    }
    
}
