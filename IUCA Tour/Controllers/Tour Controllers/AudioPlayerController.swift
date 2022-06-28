//
//  AudioPlayerController.swift
//  IUCA Tour
//
//  Created by User on 1/21/22.
//

import UIKit
import SideMenu
import AVKit
import Foundation

protocol AudioPlayerControllerDelegate: AnyObject {
    func currentPlace(placeId: Int)
}


class AudioPlayerController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: AudioPlayerControllerDelegate?

    
    let snackbarView = UIView()
    let slider = ImageSlider()
    
    var expandViewHeightConstraint: NSLayoutConstraint?
    var expandViewTopConstraint: NSLayoutConstraint?

    var textViewHeightConstraint: NSLayoutConstraint?
    
    var textViewBottomConstraint: NSLayoutConstraint?
    
    lazy var expandableViewFullHeight: CGFloat = {
        self.view.frame.height - self.calculateTopDistance()
    }()
    
    lazy var textViewFullHeight: CGFloat = {
        self.expandableViewFullHeight - self.headerOne.frame.height - self.nextDestinationButton.frame.height - 72
    }()
    
   
    lazy var textViewShortHeight: CGFloat = {
        return self.expandableViewHalfHeight*0.6
    }()
    
    lazy var expandableViewHalfHeight: CGFloat = {
        self.view.frame.height * 0.49
    }()
    
    let expandableView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    let expandButton: UIButton = {
        let button = UIButton()
        
        button.setImage(#imageLiteral(resourceName: NSLocalizedString("Expand", comment: "Localized kind: Expand")).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)
        
        
        return button
    }()
    
    let headerOne: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("ПРИХОЖАЯ", comment: "Localized kind: ПРИХОЖАЯ")
        label.font = UIFont(name: NSLocalizedString("Roboto-Medium", comment: "Localized kind: Roboto-Medium"), size: 18)
        label.textColor = .black
        
        return label
    }()
    
    var textView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont(name: NSLocalizedString("Roboto-Regular", comment: "Localized kind: Roboto-Regular"), size: 14)
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.bounces = false
        textView.isSelectable = false
        
        return textView
    }()
    
    var nextDestinationButton: UIButton = {
        let button = Utilities().createButton(withTitle: NSLocalizedString("СЛЕДУЮЩАЯ ОСТАНОВКА", comment: "Localized kind: СЛЕДУЮЩАЯ ОСТАНОВКА"),
                                              backgroundColor: .blueColorForButtons)
        
        button.addTarget(self, action: #selector(handleButtonNextDestination), for: .touchUpInside)
        
        return button
    }()
    
    let viewForAudioPlayer: UIView = {
        let view = UIView()
        view.backgroundColor = .iucaBlue
        
        return view
    }()
    
    let skipNextFifteenSecondsButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: NSLocalizedString("Artboard 1", comment: "Localized kind: Artboard 1")).withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        
        return button
    }()
    
    let rollBackNextFifteenSecondsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: NSLocalizedString("Artboard 1-2", comment: "Localized kind: Artboard 1-2")).withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: NSLocalizedString("Artboard 1-1", comment: "Localized kind: Artboard 1-1")).withRenderingMode(.alwaysOriginal), for: .normal)
      

        button.addTarget(self, action: #selector(handlePlayPauseButton), for: .touchUpInside)
        
        return button
    }()
    
    let timeSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(handleTimeSliderHasChanged), for: .touchUpInside)
        
        return slider
    }()
    
    let labelForTimeBeggining: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("00:00", comment: "Localized kind: 00:00")
        label.font = UIFont(name: NSLocalizedString("Roboto-Medium", comment: "Localized kind: Roboto-Medium"), size: 12)
        label.textColor = .white
        
        return label
    }()

    let labelForTimeEnd: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("--:--", comment: "Localized kind: --:--")
        label.font = UIFont(name: NSLocalizedString("Roboto-Medium", comment: "Localized kind: Roboto-Medium"), size: 12)
        label.textColor = .white
        
        return label
    }()
    
    let text = ""
    
    var isExpanded: Bool = false
    
    lazy var heightOfViewForAudio: CGFloat = {
        self.viewForAudioPlayer.frame.height
    }()
    
    lazy var heightOfViewForAudio1: CGFloat = 0
    
    
    let player: AVPlayer = {
        let avplayer = AVPlayer()
        avplayer.automaticallyWaitsToMinimizeStalling = false
        
        return avplayer
    }()
    
    
//    private var currentPlace: Int
    
    var imagesURLArray: [String] = []

    
    var placeOfTour: Place
    var placesArray: [Place]
    var currentPlace: Int
    var lang: String
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities().checkInternetConnection(navigationController: self.navigationController!)

        configureUI()
        configureNavBar()
        configureExpandableView()
        configureAudioPlayer()
        playAudio(audioURL: placeOfTour.audio ?? NSLocalizedString("NO DATA", comment: "Localized kind: NO DATA"), completion: {
            self.rollBackNextFifteenSecondsButton.isEnabled = true
            self.playButton.isEnabled = true
            self.skipNextFifteenSecondsButton.isEnabled = true
            self.timeSlider.isEnabled = true
        })
        setData(completion: {
            self.slider.isUserInteractionEnabled = true
        })
       
    }
    
    init(place: Place, placesArray: [Place], currentPlace: Int, lang: String?) {
        self.lang = lang ?? ""
        self.placeOfTour = place
        self.placesArray = placesArray
        self.currentPlace = currentPlace
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(NSLocalizedString("init(coder:) has not been implemented", comment: "Localized kind: init(coder:) has not been implemented"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observePlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        playButton.isEnabled = false
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.playButton.setImage(#imageLiteral(resourceName: NSLocalizedString("Play-1", comment: "Localized kind: Play-1")).withRenderingMode(.alwaysOriginal), for: .normal)
            self.playButton.isEnabled = true
        }
        
    }
    
    //MARK: - Selectors
    
    @objc func handleFastForward() {
        seekToCurrentTime(delta: 15)
    }
    
    @objc func handleRewind() {
        seekToCurrentTime(delta: -15)
    }
    
    @objc func handleTimeSliderHasChanged() {
        let persentage = timeSlider.value
        
        guard let duration = player.currentItem?.duration else {
            return
        }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        let seekTimeInSeconds = Float64(persentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        player.seek(to: seekTime)
    }
    
    @objc func handlePlayPauseButton() {
        if player.timeControlStatus == .paused {
            player.play()
            playButton.setImage(#imageLiteral(resourceName: NSLocalizedString("Play", comment: "Localized kind: Play")).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            player.pause()
            playButton.setImage(#imageLiteral(resourceName: NSLocalizedString("Artboard 1-5", comment: "Localized kind: Artboard 1-5")).withRenderingMode(.alwaysOriginal), for: .normal)

        }
    }
    
    @objc func handleButtonNextDestination() {
        player.pause()
        let placeId = (placeOfTour.currentPlaceId ?? 0) + 1
        
        delegate?.currentPlace(placeId: placeId)
        
        
    }
    
    @objc func handleExpand() {
        
        if isExpanded {
            hideAnimate()
            isExpanded = !isExpanded
        } else {
            expandAnimate()
            isExpanded = !isExpanded
        }
    }
    
    @objc func handleBurgerMenu() {
        let controller = MenuController(distance: self.calculateTopDistance(), places: placesArray, currentPlace: currentPlace)
        controller.delegate = self

        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: controller)
        
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        
//        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
//        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view,
//                                                                  forMenu: SideMenuManager.PresentDirection(rawValue: 1)!)
        
        leftMenuNavigationController.statusBarEndAlpha = 0
        
        leftMenuNavigationController.presentationStyle = .menuSlideIn
        leftMenuNavigationController.leftSide = true
        leftMenuNavigationController.menuWidth = 300
        
        
        

        present(leftMenuNavigationController, animated: true, completion: nil)
        
    }
    
    @objc func handleFinishTour() {
        player.pause()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Helpers
    
    
    func configureImages(imagesArray: [String], completion: @escaping() -> Void) {

        for imageURL in imagesArray {
            imagesURLArray.append(Utilities().createURLForImage(url: imageURL))
        }
        
        completion()
      
        
    }
    
    func setData(completion: @escaping() -> Void) {
        configureImages(imagesArray: placeOfTour.images ?? []) {
            self.slider.imagesArr = self.imagesURLArray
        }
        
        textView.text = placeOfTour.desc
        completion()
    }
    
    
    private func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTimeSeconds / durationSeconds
        
        self.timeSlider.value = Float(percentage)
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
           
            self.labelForTimeBeggining.text = time.toDisplayString()
            
            let duration = self.player.currentItem?.duration
            self.labelForTimeEnd.text = duration?.toDisplayString()
            self.updateCurrentTimeSlider()
        }
    }
    
    private func playAudio(audioURL: String, completion: @escaping() -> Void) {
        
        print("DEBUG: Audio url is : http://tour.iuca.kg\(audioURL)")
        guard let url = URL(string: ("http://tour.iuca.kg\(audioURL)")) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        completion()
        
    }
    
    private func expandAnimate() {
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.textView.isScrollEnabled = true

            self.textViewHeightConstraint?.constant = self.textViewFullHeight
            
            self.expandViewTopConstraint?.isActive = false

            
            self.expandViewTopConstraint = NSLayoutConstraint.init(item: self.expandableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1.0, constant: 0)
                    
            self.expandViewTopConstraint?.isActive = true

            
            self.view.layoutIfNeeded()
        })
    }
    
    func hideAnimate() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.textView.isScrollEnabled = false
            
            self.textViewHeightConstraint?.constant = self.textViewShortHeight
            
            self.expandViewTopConstraint?.isActive = false

            
            self.expandViewTopConstraint = NSLayoutConstraint.init(item: self.expandableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.viewForAudioPlayer, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
                    
            self.expandViewTopConstraint?.isActive = true

            
            self.view.layoutIfNeeded()
        })
    }
    
    
    func configureNavBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .iucaBlue
        
        navigationItem.title = placeOfTour.name ?? NSLocalizedString("Undefined", comment: "Localized kind: Undefined")
        
       
            
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .iucaBlue
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: NSLocalizedString("burger menu", comment: "Localized kind: burger menu")).withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self, action: #selector(handleBurgerMenu))
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        slider.isUserInteractionEnabled = false
        view.addSubview(slider)
        slider.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                      right: view.rightAnchor, height: view.frame.height * 0.26)
        
        view.addSubview(viewForAudioPlayer)
        viewForAudioPlayer.anchor(top: slider.bottomAnchor, left: view.leftAnchor,
                                  right: view.rightAnchor, height: 110)
        heightOfViewForAudio1 = viewForAudioPlayer.frame.height
        
 
    }
    
    
    func configureExpandableView() {
        view.addSubview(expandableView)
        expandableView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        expandableView.translatesAutoresizingMaskIntoConstraints = false

        expandViewTopConstraint = NSLayoutConstraint.init(item: expandableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewForAudioPlayer, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
                
        expandViewTopConstraint?.isActive = true

        expandableView.addSubview(expandButton)
        expandButton.anchor(top: expandableView.topAnchor, right: expandableView.rightAnchor,
                            paddingTop: 19, paddingRight: 18, width: 24, height: 24)
        
        expandableView.addSubview(headerOne)
        headerOne.centerX(inView: expandableView, topAnchor: expandableView.topAnchor, paddingTop: 22)
        
        if placeOfTour.currentPlaceId == -1 {
            nextDestinationButton = Utilities().createButtonWithImage(text: NSLocalizedString("Завершить экскурсию".uppercased(), comment: "Localized kind: Завершить экскурсию".uppercased()), image: #imageLiteral(resourceName: "Vector-17"), colorOfBackground: UIColor.greenColorForButton)
            nextDestinationButton.layer.cornerRadius = 10
            nextDestinationButton.addTarget(self, action: #selector(handleFinishTour), for: .touchUpInside)

            configureStackForTextViewAndButton()
        } else {
            configureStackForTextViewAndButton()
        }
        
        
        textView.text = NSLocalizedString("Загрузка...", comment: "Localized kind: Загрузка...")
    }
    
    func configureStackForTextViewAndButton() {
        headerOne.text = placeOfTour.name?.uppercased()
        
        let stack = UIStackView(arrangedSubviews: [textView, nextDestinationButton])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        
        expandableView.addSubview(stack)
        stack.anchor(top: headerOne.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                     right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 20,
                     paddingRight: 16)
    }
    
    func configureAudioPlayer() {
        rollBackNextFifteenSecondsButton.isEnabled = false
        playButton.isEnabled = false
        skipNextFifteenSecondsButton.isEnabled = false
        timeSlider.isEnabled = false

        
        let stack = UIStackView(arrangedSubviews: [rollBackNextFifteenSecondsButton, playButton, skipNextFifteenSecondsButton])

        stack.distribution = .fill
        stack.spacing = 30
        stack.axis = .horizontal
        
        viewForAudioPlayer.addSubview(timeSlider)
        timeSlider.anchor(top: viewForAudioPlayer.topAnchor, left: viewForAudioPlayer.leftAnchor, right: viewForAudioPlayer.rightAnchor, paddingTop: 10, paddingLeft: 17, paddingRight: 17)
        
        timeSlider.heightAnchor.constraint(equalToConstant: 17).isActive = true
        timeSlider.setThumbImage(#imageLiteral(resourceName: NSLocalizedString("Ellipse 17", comment: "Localized kind: Ellipse 17")), for: .normal)
        timeSlider.setThumbImage(#imageLiteral(resourceName: NSLocalizedString("Artboard 1-10", comment: "Localized kind: Artboard 1-10")), for: .highlighted)
        timeSlider.minimumTrackTintColor = .white
        timeSlider.maximumTrackTintColor = UIColor.rgb(red: 124, green: 156, blue: 219)

        viewForAudioPlayer.addSubview(stack)
        stack.centerX(inView: timeSlider, topAnchor: timeSlider.bottomAnchor, paddingTop: ((view.frame.height * 0.5) * 0.02)-3)
 
        viewForAudioPlayer.addSubview(labelForTimeBeggining)
        labelForTimeBeggining.anchor(top: timeSlider.bottomAnchor, left: view.leftAnchor, paddingLeft: 17)
        
        viewForAudioPlayer.addSubview(labelForTimeEnd)
        labelForTimeEnd.anchor(top: timeSlider.bottomAnchor, right: view.rightAnchor, paddingRight: 17)
    }
    
    
    
}


extension AudioPlayerController: SideMenuNavigationControllerDelegate {
    
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

class CustomSlider: UISlider {
   
       override func trackRect(forBounds bounds: CGRect) -> CGRect {
           let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
           super.trackRect(forBounds: customBounds)
           return customBounds
       }
   
   }


extension AudioPlayerController: MenuControllerDelegate {
    func didTapFinishTour() {
        Utilities().configureActionSheet(navigationController: self.navigationController!)
    }
    
   
}

