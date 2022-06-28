//
//  QRScannerViewController.swift
//  IUCA Tour
//
//  Created by User on 2/1/22.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    //MARK: - Properties
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    let qrScannerImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.image = #imageLiteral(resourceName: "qr-code-svgrepo-com 1")
        
        return iv
    }()
    
    private let qrScannerImageViewEmphesize: UIImageView = {
        let iv = UIImageView()
        
        iv.image = #imageLiteral(resourceName: "qr-code-svgrepo-com 1")
        
        return iv
    }()
    
    private let transperrentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.rgb(red: 22, green: 22, blue: 22).withAlphaComponent(0.61)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let labelForView: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
      
        
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        
        label.text = """
                     Направьте камеру
                     на QR-код рядом с Вами,
                     чтобы определить Ваше
                     текущее местоположение
                     """
        
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureCamera()
        configureUI()
        Utilities().checkInternetConnection(navigationController: self.navigationController!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavBar()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleDissmisQRScanner() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureNavBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .iucaBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Vector-14").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self, action: #selector(handleDissmisQRScanner))
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
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
//                print(metadataObj.stringValue)
            }
        }
    }
    
    func configureCamera() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
//            videoPreviewLayer?.addSublayer(qrScannerImageView.layer)
            
//            view.bringSubviewToFront(qrScannerImageView)
            
            captureSession.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                
                qrCodeFrameView.addSubview(qrScannerImageViewEmphesize)
                qrScannerImageViewEmphesize.addConstraintsToFillView(qrCodeFrameView)
//                qrCodeFrameView.layer.borderColor = UIColor.yellow.cgColor
//                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
               
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        
        view.addSubview(qrScannerImageView)
        qrScannerImageView.center(inView: view)
        qrScannerImageView.setDimensions(width: 231, height: 231)
        view.bringSubviewToFront(qrScannerImageView)
        
        view.addSubview(transperrentView)
        transperrentView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: view.frame.height * 0.1, paddingRight: 16, height: 100)
        
        transperrentView.addSubview(labelForView)
        labelForView.center(inView: transperrentView)
        
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
