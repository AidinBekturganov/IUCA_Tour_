//
//  GoToNextDestinationController.swift
//  IUCA Tour
//
//  Created by User on 1/17/22.
//

import UIKit
import SideMenu
import SDWebImage
import SideMenuSwift

protocol GoNextDestinationDelegate: AnyObject {
    func handleMenuToggle()
}

class GoToNextDestinationController: UIViewController {
    
    
    //MARK: - Properties
    
    weak var delegate: GoNextDestinationDelegate?
    
    
    
    private let labelOne: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.textColor = .black
        
        label.text = "Данная остановка:"
        
        return label
    }()
    
    private let labelTwo: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.textColor = .black
        
        
        label.text = "СТОЛОВОЙ"
        
        return label
    }()
    
    
    private let imageOfDestination: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        
        iv.clipsToBounds = true
        return iv
    }()
    
    private let gotToPlace: UIButton = {
        let button = Utilities().createButton(withTitle: "ПЕРЕЙТИ",
                                              backgroundColor: .blueColorForButtons)
        
        button.addTarget(self, action: #selector(handleButtonIAmHere), for: .touchUpInside)
        
        
        
        return button
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        return view
    }()
    
    
    
    
    private var nav: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let snackbarView = UIView()
    
    private let lostButton: UIButton = {
        let button = UIButton()
        let viewDivider = UIView()
        
        viewDivider.backgroundColor = .black
        button.addSubview(viewDivider)
       
        viewDivider.anchor(top: button.bottomAnchor, left: button.leftAnchor, right: button.rightAnchor, paddingTop: 0.1)
        viewDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        button.setTitle("Потерялись?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(handleLostButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var placesArray: [Place]?
    
    private var currentPlace: Int = 0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        Utilities().checkInternetConnection(navigationController: self.navigationController!)

    }
    
    init(places: [Place]) {
        self.placesArray = places
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleLostButtonPressed() {
        let controller = UINavigationController(rootViewController: QRScannerViewController())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleButtonIAmHere() {
      
       if placesArray?[safe: (placesArray?.count ?? 0) - 1]?.name == placesArray?[safe: currentPlace]?.name {
           print("DEBUG THERE IS NO PLACE \(currentPlace)")
        
            if var place = placesArray?[safe: currentPlace] {
                place.currentPlaceId = -1
                
                createPresentView(place: place)
            }
       } else {
            if var place = placesArray?[safe: currentPlace] {
                place.currentPlaceId = currentPlace
                
                createPresentView(place: place)
            }
            
        }
       
    }
    
    @objc func handleBurgerMenu() {
        let controller = MenuController(distance: self.calculateTopDistance(), places: placesArray ?? [], currentPlace: currentPlace)
        controller.delegate = self
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: controller)
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: SideMenuManager.PresentDirection(rawValue: 1)!)
        leftMenuNavigationController.statusBarEndAlpha = 0
        
        leftMenuNavigationController.presentationStyle = .menuSlideIn
        leftMenuNavigationController.leftSide = true
        leftMenuNavigationController.menuWidth = 300

        present(leftMenuNavigationController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Helpers
    
    private func configureNavigationBar() {
        navigationItem.title = "Экскурсия"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .iucaBlue
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    private func createPresentView(place: Place) {
        let contoller = AudioPlayerController(place: place, placesArray: placesArray ?? [], currentPlace: currentPlace, lang: nil)
        contoller.delegate = self
        let nav = UINavigationController(rootViewController: contoller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        
        let sizeOfHeight = view.frame.height
        
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "burger menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBurgerMenu))
//        touch.view.isUserInteractionEnabled = false
        let stack = UIStackView(arrangedSubviews: [labelOne, labelTwo])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.alignment = .center
        
        view.addSubview(stack)
        stack.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: sizeOfHeight * 0.05)
        
        view.addSubview(imageOfDestination)
        
        imageOfDestination.centerX(inView: view, topAnchor: stack.bottomAnchor, paddingTop: 50)
        imageOfDestination.layer.cornerRadius = (sizeOfHeight / 2.4) / 2
        imageOfDestination.setDimensions(width: sizeOfHeight / 2.4, height: sizeOfHeight / 2.4)
        
       
        
        view.addSubview(lostButton)
//        lostButton.setDimensions(width: 50, height: 10)

//        lostButton.centerX(inView: view, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
//        lostButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        


        view.addSubview(gotToPlace)
        gotToPlace.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingLeft: 16, paddingBottom: 32, paddingRight: 16)
        
        setDataToElements()
        
    }
    
    private func setDataToElements() {
        labelTwo.text = placesArray?[currentPlace].name?.uppercased()

        guard let url = URL(string: Utilities().createURLForImage(url: placesArray?[currentPlace].images?[0] ?? "")) else { return }
        imageOfDestination.sd_setImage(with: url, completed: nil)
    }
}

extension GoToNextDestinationController: SideMenuNavigationControllerDelegate {
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        self.navigationController?.view.isUserInteractionEnabled = false
        Utilities().hideShadowView(shadowView: snackbarView, completionHandler: {
            self.navigationController?.view.isUserInteractionEnabled = true

        })
    }
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        Utilities().setupViewToAnimate(shadowView: snackbarView, controllerView: self.view)
    }
}

extension GoToNextDestinationController: MenuControllerDelegate {
    func didTapFinishTour() {
        Utilities().configureActionSheet(navigationController: self.navigationController!)
    }
    
   
}


extension GoToNextDestinationController: AudioPlayerControllerDelegate {
    func currentPlace(placeId: Int) {
        dismiss(animated: true) {
            self.currentPlace = placeId
            DispatchQueue.main.async {
                self.setDataToElements()
            }
        }
       
    }
}


