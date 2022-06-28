//
//  QRDetailsController.swift
//  IUCA Tour
//
//  Created by User on 2/7/22.
//

import UIKit

class QRDetailsController: AudioPlayerController {

//    private var placeArray: [Place]

    
    private lazy var langBarButton = Utilities().createCustomBarButton(buttonType: lang)

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        if NetworkMonitor.shared.isConnected {
            configureUI()
            configureNavBar()
            configureExpandableView()
            configureAudioPlayer()
            configureNavButton()
            print("DEBUG: the lang is : \(lang)")
            setData(completion: {
                self.slider.isUserInteractionEnabled = true
            })
        } else {
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
      
    }
    
    override init(place: Place, placesArray: [Place], currentPlace: Int, lang: String?) {
        super.init(place: place, placesArray: placesArray, currentPlace: currentPlace, lang: lang)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissController() {
        dismiss(animated: true)
    }
    
    @objc func handleExplored() {
        dismiss(animated: true)
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
    
    //MARK: - API Service
    
    private func fetchPlaces(completion: @escaping() -> Void) {
        
        ApiService.shared.fetchPlacesOfTour(language: lang) { places in
            self.placesArray = places
            completion()
        }
       
    }
    
    //MARK: - Helpers
    
    override func setData(completion: @escaping() -> Void) {
        configureImages(imagesArray: placesArray[currentPlace].images ?? []) {
            self.slider.imagesArr = self.imagesURLArray
            DispatchQueue.main.async {
                self.textView.text = self.placesArray[self.currentPlace].desc
            }
           
        }
        
        
        completion()
    }
  

    override func configureExpandableView() {
        
        view.addSubview(expandableView)
        expandableView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        expandableView.translatesAutoresizingMaskIntoConstraints = false

        expandViewTopConstraint = NSLayoutConstraint.init(item: expandableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: slider, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
                
        expandViewTopConstraint?.isActive = true

        expandableView.addSubview(expandButton)
        expandButton.anchor(top: expandableView.topAnchor, right: expandableView.rightAnchor,
                            paddingTop: 19, paddingRight: 47, width: 24, height: 24)
        
        expandableView.addSubview(headerOne)
        headerOne.centerX(inView: expandableView, topAnchor: expandableView.topAnchor, paddingTop: 22)
        
        nextDestinationButton = Utilities().createButton(withTitle: "ИЗУЧЕНО",
                                                         backgroundColor: .blueColorForButtons)
        nextDestinationButton.addTarget(self, action: #selector(handleExplored), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [textView, nextDestinationButton])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        
        expandableView.addSubview(stack)
        stack.anchor(top: headerOne.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                     right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 20,
                     paddingRight: 16)
        
        textView.text = text
    }
    
    override func hideAnimate() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.textView.isScrollEnabled = false
            
            self.textViewHeightConstraint?.constant = self.textViewShortHeight
            
            self.expandViewTopConstraint?.isActive = false

            
            self.expandViewTopConstraint = NSLayoutConstraint.init(item: self.expandableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.slider, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
                    
            self.expandViewTopConstraint?.isActive = true

            
            self.view.layoutIfNeeded()
        })
    }
    
    override func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(slider)
        slider.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                      right: view.rightAnchor, height: view.frame.height * 0.26)
        
    }
    private func configureNavButton() {
       
    }
    
        
    override func configureNavBar() {
        super.configureNavBar()
        navigationItem.title = "Изучение"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: langBarButton)
        langBarButton.addTarget(self, action: #selector(handleChooseLanguageEngForBarButton), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Artboard 1-8").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self, action: #selector(handleDismissController))

    }
    
    override func configureAudioPlayer() {
        
    }
}

extension QRDetailsController: SelectLanguageDelegate {
    func selectLang(lang: String) {
        dismiss(animated: true) {
            Utilities().saveLangToTheMemory(lang: lang)
            self.lang = lang
            self.langBarButton = Utilities().createCustomBarButton(buttonType: lang)
            self.configureNavBar()
            self.imagesURLArray = []
            self.fetchPlaces {
                self.setData(completion: {
                    DispatchQueue.main.async {
                        self.slider.isUserInteractionEnabled = true
                    }
                })
            }
        }
        
    }
}
