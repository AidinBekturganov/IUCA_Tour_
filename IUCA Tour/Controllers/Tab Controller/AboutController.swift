//
//  FeedController.swift
//  IUCA Tour
//
//  Created by User on 1/3/22.
//

import UIKit

class AboutController: UIViewController {
    
    //MARK: - Properties
    
    private let slider = ImageSlider()
    
    private let headerOne: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.textColor = .black
        label.numberOfLines = 0
        
        label.text = """
                    Международный университет
                    в Центральной Азии
                    """
        label.textAlignment = .center
        
        return label
    }()
    
    private let headerTwo: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Roboto-Medium", size: 14)
        label.textColor = UIColor.rgb(red: 84, green: 83, blue: 86)
        
        label.text = "Кыргызстан, г. Токмок, ул. Шамсинская 2"
        label.textAlignment = .left
        
        return label
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont(name: "Roboto-Regular", size: 14)
        textView.textColor = .black
        textView.backgroundColor = .white
        //        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.bounces = false
        textView.isSelectable = false
        textView.textAlignment = .left
        
        return textView
    }()
    
    private let text = """
                        Международный университет в Центральной Азии создан на основе американской модели высшего образования, формирующей ярких высокообразованных лидеров современного демократического общества. Основополагающими принципами университета являются академическая честность и академическая свобода. Университет зарекомендовал себя как проводник интеллектуальной свободы и безопасной, свободной от коррупции среды.
                        Миссия университета направлена на формирование глобально мыслящих ответственных лидеров, приверженных честности, способных интегрировать свои личные и профессиональные навыки в целях служения обществу.

                        Стратегические цели вуза:

                        Формирование современного инновационного многоуровневого образовательного комплекса
                        Открытие Высшей школы бизнеса, экономики и информационных технологий им. Янга
                        Открытие магистратуры на всех программах по программе двойных дипломов
                        Вхождение в число 10 лучших университетов Центральной Азии
                         
                        Достоинства вуза.

                        - Политика академической свободы и академической честности. Принципы академической свободы и честности позволяют добиваться более высокого качественного уровня образования. Мы стремимся не нарушать принципы равенства и справедливости, не дискриминируем сотрудников и студентов по причине социального или этнического статуса.
                        - Высокий качественный уровень профессорско-преподавательского состава. Мы привлекаем лучших преподавателей страны (бывший министр образования, бывший судья Конституционного суда, бывший председатель Национального банка КР, бывший советник премьер-министра), лучшие иностранные преподаватели из США, Индии, Великобритании, Тайваня, Китая и Канады.
                        - Вклад в региональное развитие. В объявленный 2019 г. Президентом КР Год развития регионов и цифровизации, мы начинаем значительный инвестиционный проект по строительству нового кампуса в Токмоке, который станет одним из лучших региональных проектов страны и создаст новые рабочие места. Мы охватываем население региона, прежде всего, этнические меньшинства Токмока и Чуйской области.
                        - Личностно-центрированный подход к обучению. МУЦА является единственным вузом в стране, в котором начинается регулярное исследование познавательных и личностных особенностей, этического и интеллектуального развития каждого студента. В исследовании применяются достоверные и надежные инструменты, разработанные в ведущих университетах США.
                        - Формирование социальной ответственности студентов является целью каждой программы.
                        - Постоянная работа над улучшением инфраструктуры. В 2018 году приобретено 13 благоустроенных квартир в центре города Токмок, проведен ремонт. В 2019 году арендована земля и заложена основа для постройки нового кампуса.
                       """
    
    private var lang: String
    
    
    private lazy var langBarButton = Utilities().createCustomBarButton(buttonType: lang)
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 9)
        label.textColor = .white
        label.textAlignment = .center
        
        
        button.setImage(#imageLiteral(resourceName: "Vector-16").withRenderingMode(.alwaysOriginal), for: .normal)
        label.text = "Язык"
                
        return button
    }()
    
    private let butt: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 9)
        label.textColor = .white
        label.textAlignment = .center
        
        
        button.setImage(#imageLiteral(resourceName: "Ellipse 10").withRenderingMode(.alwaysOriginal), for: .normal)
        label.text = "Язык"
        
        
        
//        button.frame = CGRect(x: 0, y: 0, width: 50, height: 42)
//
//
//        button.addSubview(label)
//        label.centerX(inView: button, topAnchor: button.bottomAnchor, paddingTop: 0)
        
        return button
    }()
    
    private var arrayOfURLsOfImages = [String]()
    private var placesArray: [Place]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NetworkMonitor.shared.isConnected {
            configureUI()
            configureBarButtonItem()
        } else {
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    init(lang: String, places: [Place]) {
        self.lang = lang
        self.placesArray = places
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    @objc func handleShareButton() {
        
        print("DEBUG: Working")
        
        guard let url = URL(string: "https://www.google.com") else {
            return
        }
        
        
        
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                
        self.present(vc, animated: true, completion: nil)
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
    

    //MARK: - Helpers
    
    private func passDataToSlider(places: [Place]) {
        for i in 0..<places.count {
            let place = places[i]
            
            if let placeImages = place.images {
                for j in 0..<placeImages.count{
                    print("DEBUG: the places image \(place.images?[j] ?? "NO DATA")")
                    
                    arrayOfURLsOfImages.append(Utilities().createURLForImage(url: place.images?[j] ?? ""))
                }
            }
           
        }
        slider.imagesArr = arrayOfURLsOfImages

    }
    
    
    func configureBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: langBarButton)
        langBarButton.addTarget(self, action: #selector(handleChooseLanguageEngForBarButton), for: .touchUpInside)
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: butt)
        

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: shareButton)
        shareButton.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)


    }
    
    
    
    func configureUI() {
        view.backgroundColor = .white
        self.passDataToSlider(places: placesArray)

        
        navigationItem.title = "О МУЦА"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .iucaBlue
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        view.addSubview(slider)
        slider.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                      right: view.rightAnchor, width: view.frame.width, height: view.frame.height * 0.26)
        
        view.addSubview(headerOne)
        headerOne.centerX(inView: view, topAnchor: slider.bottomAnchor, paddingTop: 14)
        
        view.addSubview(headerTwo)
        headerTwo.anchor(top: headerOne.bottomAnchor, left: view.leftAnchor, paddingTop: 18, paddingLeft: 16)
        
        textView.text = text
        
        view.addSubview(textView)
        textView.anchor(top: headerTwo.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 18, paddingLeft: 16, paddingRight: 16)
        
    }
}

extension AboutController: SelectLanguageDelegate {
    func selectLang(lang: String) {
        dismiss(animated: true) {
            Utilities().saveLangToTheMemory(lang: lang)
            self.lang = lang
            self.langBarButton = Utilities().createCustomBarButton(buttonType: lang)
            self.configureBarButtonItem()
        }
        
    }
}
