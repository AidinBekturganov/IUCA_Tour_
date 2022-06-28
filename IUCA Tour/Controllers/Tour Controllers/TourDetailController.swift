//
//  TourDetailController.swift
//  IUCA Tour
//
//  Created by User on 1/15/22.
//


import UIKit
import SideMenu
import SDWebImage

protocol TourDetailControlleDelegate: AnyObject {
    func choosenLanguage(lang: String)
}


class TourDetailController: UIViewController {
    //MARK: - Properties
    
    private var slider = ImageSlider()
    
    weak var delegate: TourDetailControlleDelegate?
    
    
    private var stopList = StopList()
    
  
    
    
    private let labelForDistance: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        
        label.text = "1-2 км"
       

        return label
    }()
    
    private let labelTimeOfTour: UILabel = {
        let label = UILabel()
        label.textColor = .black

        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.text = "10 мин"
        
        return label
    }()
    
    private let labelTimeOfAudio: UILabel = {
        let label = UILabel()
        label.textColor = .black

        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.text = "5 мин"

        return label
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black

        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.text = "ОПИСАНИЕ ВАШЕЙ ЭКСКУРСИИ"

        return label
    }()
    
    private let imageOfDistance: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "123")
        return iv
    }()
    
    private let imageOfTimeTour: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Asset 1")

        return iv
    }()
    
    private let imageOfTimeAudio: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Asset 2")

        return iv
    }()
    
    private let mapImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.image = #imageLiteral(resourceName: "image 3")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let secondLabelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.textColor = .black

        label.text = "ОСТАНОВКИ ВАШЕЙ ЭКСКУРСИИ:"

        return label
    }()
    
    private let startExcursionButton: UIButton = {
        let button = Utilities().createButton(withTitle: "НАЧАТЬ ЭКСКУРСИЮ",
                                              backgroundColor: .blueColorForButtons)
        
        button.addTarget(self, action: #selector(handleStartToExcursion), for: .touchUpInside)
        
        
        
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
    
    private var placesArray = [Place]() {
        didSet {
            stopList.placesArray = placesArray
        
            configureImages(completion: {

                self.slider.imagesArr = self.imagesURLArray
            })
        }
    }
    
    private let loadingIndicator: ProgressView = {
        let progressView = ProgressView(colors: [.iucaBlue], lineWidth: 3)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    private var placeArray: [Place] = []
    private var imagesURLArray: [String] = []
    private var idOfPreset: Int
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.configureUI()
        self.configureBarButton()

       
          
        self.fetchPlaces { data in

            let sortedData = data.sorted {
                $0.order ?? 0 < $1.order ?? 0
            }
            
            
            self.placesArray = sortedData
            DispatchQueue.main.async {
                self.loadingIndicator.isAnimating = false
            }
        }
          
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("The debug is fired")
    }
    
    init(lang: String, idOfPreset: Int) {
        self.lang = lang
        self.idOfPreset = idOfPreset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Selectors
    
    @objc func handleStartToExcursion() {
       
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: GoToNextDestinationController(places: placesArray))
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        
                
        let nav = UINavigationController(rootViewController: GoToNextDestinationController(places: placesArray))
        
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
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API Service
    
    private func fetchPlaces(completion: @escaping([Place]) -> Void) {

        DispatchQueue.main.async {

            ApiService.shared.fetchPresetOfTour(idOfPreset: self.idOfPreset) { preset in
                let sortedPresets = preset.places.sorted {
                    $0.order ?? 0 < $1.order ?? 0
                }
//               print(sortedPresets)

                for place in sortedPresets {
                    ApiService.shared.fetchPlaceOfTour(idOfPlace: place.place ?? 0, language: self.lang.uppercased()) { data in
//                        print("DEBUG the amount of arr \(sortedPresets.count)")
                        var placeData = data
                        placeData.order = place.order
                        self.placeArray.append(placeData)
//                        print("DEBUG: The placees count: \(data.name)")


                        if self.placeArray.count == (sortedPresets.count) {
//                            print("DEBUG: The placees count finish: \(data.name)")
                            completion(self.placeArray)
                        }
                    }

                }

            }
        }

       
    }
    
    //MARK: - Helpers
    
    private func configureImages(completion: @escaping() -> Void) {

        for place in placesArray {

            imagesURLArray.append(Utilities().createURLForImage(url: place.images?[0] ?? ""))
        }
        
        completion()
      
        
    }
    
    
    func configureBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cusButton)
        cusButton.addTarget(self, action: #selector(handleChooseLanguageEngForBarButton), for: .touchUpInside)
        
    }
    
    func configureUI() {
        
      
        
        view.backgroundColor = .white
        
        navigationItem.title = "О МУЦА"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        
        view.addSubview(slider)
        slider.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                      right: view.rightAnchor, width: view.frame.width, height: view.frame.height * 0.26)
     
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .iucaBlue
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        navigationItem.title = "Экскурсия"


        let stackForDistance = UIStackView(arrangedSubviews: [imageOfDistance, labelForDistance])
        stackForDistance.axis = .horizontal
        stackForDistance.spacing = 11
        stackForDistance.distribution = .fill
        
        let stackForTimeOfTour = UIStackView(arrangedSubviews: [imageOfTimeTour, labelTimeOfTour])
        stackForTimeOfTour.axis = .horizontal
        stackForTimeOfTour.spacing = 11
        stackForTimeOfTour.distribution = .fill

        let stackForAudioTime = UIStackView(arrangedSubviews: [imageOfTimeAudio, labelTimeOfAudio])
        stackForAudioTime.axis = .horizontal
        stackForAudioTime.spacing = 11
        stackForAudioTime.distribution = .fill

        let stack = UIStackView(arrangedSubviews: [stackForDistance, stackForTimeOfTour, stackForAudioTime])
        stack.axis = .horizontal
        stack.spacing = 45
        stack.distribution = .fillProportionally
        
        view.addSubview(labelTitle)
        labelTitle.centerX(inView: view, topAnchor: slider.bottomAnchor, paddingTop: 10)
        
        view.addSubview(stack)
        stack.centerX(inView: view, topAnchor: labelTitle.bottomAnchor, paddingTop: 12)
        
//        view.addSubview(mapImageView)
//        mapImageView.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: view.frame.height / 5)
        
        view.addSubview(secondLabelTitle)
        secondLabelTitle.centerX(inView: view, topAnchor: stack.bottomAnchor, paddingTop: 30)
        
        view.addSubview(stopList)
        stopList.anchor(top: secondLabelTitle.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10)
        
//        stopList.addSubview(loadingIndicator)
//        loadingIndicator.center(inView: stopList)
        
        slider.addSubview(loadingIndicator)
        loadingIndicator.center(inView: slider)
        
        loadingIndicator.isAnimating = true
        
        view.addSubview(startExcursionButton)
        startExcursionButton.anchor(top: stopList.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 16, paddingBottom: 5, paddingRight: 16)
    }
}


extension TourDetailController: SelectLanguageDelegate {
    func selectLang(lang: String) {
        self.dismiss(animated: true) {
            
            self.placeArray = []
            self.placesArray = []
            self.stopList.placesArray = []
            self.imagesURLArray = []
            
            self.lang = lang
            self.fetchPlaces { data in
                
                let sortedData = data.sorted {
                    $0.order ?? 0 < $1.order ?? 0
                }
                
                
                
                DispatchQueue.main.async {
                    Utilities().saveLangToTheMemory(lang: lang)
                    
                    self.stopList = StopList()
                    self.cusButton = Utilities().createCustomBarButton(buttonType: lang)
                    self.configureBarButton()
                    self.configureUI()
                    self.placesArray = sortedData
                }
                
                
            }
            
            
                    
        }
            

        
       
        
    }
}
