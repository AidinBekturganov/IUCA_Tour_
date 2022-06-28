//
//  ExcursionController.swift
//  IUCA Tour
//
//  Created by User on 1/3/22.
//

import UIKit

class ExcursionController: UIViewController {
    //MARK: - Properties
    
    private let actionSheet: ActionSheetLauncher
    
    private let labelHeaderOne: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.textColor = .black
        label.text = "ГЛАВНЫЙ КОРПУС МУЦА"
        return label
    }()
    
    private let labelSmallText: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Roboto-Regular", size: 22)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        
        label.text = """
                    Начните экскурсию,
                    чтобы познакомиться
                    с историей и атмосферой МУЦА!
                    """
        label.textAlignment = .center
        return label
    }()
    
    
    private let illustrationOfMandD: UIImageView = {
        let iv = UIImageView()
        
        iv.image = #imageLiteral(resourceName: "Welcome--5ec7b8b301d036001ad4f948")
        
        return iv
    }()
    
    private let startExcursionButton: UIButton = {
        let button = Utilities().createButton(withTitle: "ПЕРЕЙТИ К ЭКСКУРСИИ",
                                              backgroundColor: .white)
        button.setTitleColor(UIColor.rgb(red: 57, green: 67, blue: 144), for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 17)
        button.addTarget(self, action: #selector(handleGoToExcursion), for: .touchUpInside)
        
        
        
        return button
    }()
    
    
    
    
    private var lang: String
    
    private lazy var cusButton = Utilities().createCustomBarButton(buttonType: lang)
    
    private var sizeOfFrame: CGFloat = 0
    private var placesArray: [Place]

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        }
    
    //MARK: - Lifecycle
    
    init(lang: String, places: [Place]) {
        self.lang = lang
        self.placesArray = places
        self.actionSheet = ActionSheetLauncher()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureBarButtonItem()
        
        while(!NetworkMonitor.shared.isConnected) {
            let alert = UIAlertController(title: "no Internet", message: "This App Requires wifi/internet connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                print("NO internet")
            }))
            self.present(self, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        while(!NetworkMonitor.shared.isConnected) {
            let alert = UIAlertController(title: "no Internet", message: "This App Requires wifi/internet connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                print("NO internet")
            }))
            self.present(self, animated: true, completion: nil)
        }
    }
    
//
    
    //MARK: - Selectors
    
    @objc func handleChooseLanguageEngForBarButton() {
        DispatchQueue.main.async {
            
            let controller = SelectLanguageController()
            
            controller.delegate = self
            
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @objc func handleGoToExcursion() {
        
        let nav = SubclassNavigationController(rootViewController: ChooseTypeOfTourController(lang: self.lang))
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
//        configureActionSheet()
    }
    
    //MARK: - Helpers
    
    
    func configureActionSheet() {
        
        let text = """
                Вы сейчас находитесь
                в главном корпусе МУЦА?
            """
        
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .actionSheet)
        
        
        
        let sendButton = UIAlertAction(title: "Да, я здесь", style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: ChooseTypeOfTourController(lang: self.lang))
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        })
        
        let  deleteButton = UIAlertAction(title: "Нет, я удаленно", style: .default, handler: { (action) -> Void in
            print("Delete button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func configureBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cusButton)
        cusButton.addTarget(self, action: #selector(handleChooseLanguageEngForBarButton), for: .touchUpInside)
    }
    
    func configureUI() {
        
        let controller = ChooseTypeOfTourController(lang: lang)
        controller.delegate = self
        
        sizeOfFrame = view.safeAreaLayoutGuide.layoutFrame.height
        view.backgroundColor = .white

        
        if #available(iOS 15.0, *) { // For compatibility with earlier iOS.
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .iucaBlue
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        

        
        
        
        navigationItem.title = "Экскурсия"

        
        view.addSubview(illustrationOfMandD)
        illustrationOfMandD.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        illustrationOfMandD.setDimensions(width: 341, height: 341)
        
        let blueView = Utilities().createViewForBackground(color: .iucaBlue)

        
    
        view.addSubview(blueView)
        blueView.anchor(top: illustrationOfMandD.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        let viewOne = UIView()
        viewOne.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let viewTwo = UIView()
        viewTwo.widthAnchor.constraint(equalToConstant: 16).isActive = true
    
        let stackForButton = UIStackView(arrangedSubviews: [viewTwo, startExcursionButton, viewOne])
        stackForButton.axis = .horizontal
        
        let stack = UIStackView(arrangedSubviews: [UIView(), UIView(), labelSmallText, UIView(), stackForButton, UIView(), UIView()])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        
        blueView.addSubview(stack)
        stack.addConstraintsToFillView(blueView)

        
        
    }
}

extension ExcursionController: SelectLanguageDelegate {
    func selectLang(lang: String) {
        dismiss(animated: true) {
            Utilities().saveLangToTheMemory(lang: lang)
            self.lang = lang
            self.cusButton = Utilities().createCustomBarButton(buttonType: lang)
            self.configureBarButtonItem()
        }
        
    }
}

extension ExcursionController: ChooseTypeOfTourDelegate {
    func choosenLanguage(lang: String) {
        self.lang = lang
        self.cusButton = Utilities().createCustomBarButton(buttonType: lang)
        self.configureBarButtonItem()
    }
    
}

