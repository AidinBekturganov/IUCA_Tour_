//
//  MenuController.swift
//  IUCA Tour
//
//  Created by User on 1/17/22.
//

import UIKit

protocol MenuControllerDelegate: AnyObject {
    func didTapFinishTour()
}


class MenuController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MenuControllerDelegate!
    
    var tableView: UITableView!
    
    private let navBar: UIView = {
        let view = UIView()
        
        view.backgroundColor = .iucaBlue
        
        return view
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.rgb(red: 227, green: 224, blue: 224).withAlphaComponent(0.3)
        
        return view
    }()
    
    private let leftBarButton: UIButton = {
        let button = UIButton()
        
        button.setImage(#imageLiteral(resourceName: "Vector-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCloseBurgerMenu), for: .touchUpInside)
        
        return button
    }()
        
    private var distance: CGFloat
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Прихожая"
        
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        
        return label
    }()
    
    private let labelExcursion: UILabel = {
        let label = UILabel()
        
        label.text = "Ваша экскурсия"
        label.font = .boldSystemFont(ofSize: 18)

        label.textColor = .white
        
        return label
    }()
    
    private let labelList: UILabel = {
        let label = UILabel()
        
        label.text = "Список остановок"
        
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        
        return label
    }()
    
    private let numberOfStops: UILabel = {
        let label = UILabel()
        
        label.text = "0/0 остановок"
        label.font = .systemFont(ofSize: 16)

        label.textColor = .white
        
        return label
    }()
    
    private let minuteLabel: UILabel = {
        let label = UILabel()
        
        label.text = "3 минуты осталось"
        
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        
        return label
    }()
    
    private let markImage: UIImageView = {
        let image = UIImageView()
       
        image.image = #imageLiteral(resourceName: "bmitem")
        
        return image
    }()
    
    private let clockImage: UIImageView = {
        let image = UIImageView()
       
        image.image = #imageLiteral(resourceName: "bmitemclock")
        
        return image
    }()
    
    private let finishTourButton: UIButton = {
        let button = Utilities().createButtonWithImage(text: "Завершить экскурсию".uppercased(), image: #imageLiteral(resourceName: "Vector-3"), colorOfBackground: UIColor.rgb(red: 201, green: 80, blue: 56))
        button.addTarget(self, action: #selector(handleFinishTour), for: .touchUpInside)
        
        return button
    }()
    
    
//    private let placesCollectionView = PlacesListView()
    private var places: [Place]
    private var currentPlace: Int
    
    // MARK: - Lifecycle
    
    init(distance: CGFloat, places: [Place], currentPlace: Int) {
        self.places = places
        self.currentPlace = currentPlace
        self.distance = distance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        passDataToCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStopsList()
    }
    
    // MARK: - Selectors
    
    @objc func handleFinishTour() {
        dismiss(animated: true) {
            self.delegate.didTapFinishTour()

        }
//        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCloseBurgerMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func updateStopsList() {
        numberOfStops.text = "\(currentPlace + 1)/\(places.count) остановок"
    }
    
    private func passDataToCollectionView() {
        let collectionViewController = PlacesListView()
        collectionViewController.currentId = currentPlace
        collectionViewController.placesArray = places
        view.addSubview(collectionViewController)
        collectionViewController.anchor(top: labelList.bottomAnchor, left: view.leftAnchor, bottom: finishTourButton.topAnchor, right: view.rightAnchor, paddingTop: 25, paddingBottom: 5)
    }
    
    func configureUI() {
        
        configureNavBar()
        configureExcursionDescription()
        configureTableViewForListOfStops()
        
    }
    
    func configureExcursionDescription() {
        navBar.addSubview(headerLabel)
        headerLabel.centerX(inView: navBar, bottomAnchor: dividerView.topAnchor, paddingBottom: 12)
        
        let viewSpacer = UIView()
        viewSpacer.anchor(width: 2)
        
        let stackStops = UIStackView(arrangedSubviews: [markImage, numberOfStops, UIView()])
        stackStops.axis = .horizontal
        stackStops.spacing = 20
        
        let stackSpaceForStops = UIStackView(arrangedSubviews: [viewSpacer, stackStops])
        
        let stackMinutes = UIStackView(arrangedSubviews: [clockImage, minuteLabel, UIView()])
        
        stackMinutes.axis = .horizontal
        stackMinutes.spacing = 18

        let stack = UIStackView(arrangedSubviews: [UIView(), labelExcursion, stackSpaceForStops, stackMinutes, UIView()])
        
        stack.axis = .vertical
        stack.spacing = 10
        
        stack.distribution = .equalCentering
        
        navBar.addSubview(stack)
        stack.anchor(top: dividerView.bottomAnchor, left: navBar.leftAnchor, bottom: navBar.bottomAnchor, right: navBar.rightAnchor, paddingLeft: 20, paddingRight: 20)
    }
    
  
    func configureNavBar() {
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(navBar)
        
        navBar.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: self.view.frame.height * 0.35)
        
        navBar.addSubview(dividerView)
        dividerView.anchor(top: navBar.topAnchor, left: navBar.leftAnchor, right: navBar.rightAnchor, paddingTop: distance, height: 1)
        
        navBar.addSubview(leftBarButton)
        leftBarButton.anchor(left: navBar.leftAnchor, bottom: dividerView.topAnchor, paddingLeft: 20, paddingBottom: 12, width: 14, height: 22)
    }
    
    func configureTableViewForListOfStops() {
        view.addSubview(labelList)
        labelList.anchor(top: navBar.bottomAnchor, left: view.leftAnchor, paddingTop: distance * 0.4, paddingLeft: 18)
        
        view.addSubview(finishTourButton)
        finishTourButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 50)
        
     
    }
    
}

