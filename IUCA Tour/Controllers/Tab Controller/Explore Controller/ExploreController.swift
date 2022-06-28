//
//  ExploreController.swift
//  IUCA Tour
//
//  Created by User on 1/3/22.
//

import UIKit
import AVFoundation

class ExploreController: QRScannerViewController {
    
    //MARK: - Properties
    
    private var lang: String
    
    private lazy var langBarButton = Utilities().createCustomBarButton(buttonType: lang)
    private var placesArray: [Place]

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NetworkMonitor.shared.isConnected {
            configureBarButtonItem()
        } else {
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.langBarButton = Utilities().createCustomBarButton(buttonType: lang)
//        self.configureBarButtonItem()
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
    
    override func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            
            qrCodeFrameView?.frame = CGRect.zero
            qrScannerImageView.isHidden = false
            print("NO qr code")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            qrScannerImageView.isHidden = true
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                if placesArray.contains(where: { $0.id == Int(metadataObj.stringValue ?? "")}) {
                    let controller = QRDetailsController(place: Place(), placesArray: placesArray, currentPlace: (Int(metadataObj.stringValue ?? "") ?? 0 - 1), lang: lang)
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func configureBarButtonItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: langBarButton)
        langBarButton.addTarget(self, action: #selector(handleChooseLanguageEngForBarButton), for: .touchUpInside)
    }
    
    override func configureNavBar() {

        navigationItem.title = "Изучение"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
     
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .iucaBlue
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    
}

extension ExploreController: SelectLanguageDelegate {
    func selectLang(lang: String) {
        dismiss(animated: true) {
            Utilities().saveLangToTheMemory(lang: lang)
            self.lang = lang
            self.langBarButton = Utilities().createCustomBarButton(buttonType: lang)
            self.configureBarButtonItem()
        }
        
    }
}
