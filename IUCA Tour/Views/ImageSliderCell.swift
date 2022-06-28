//
//  ImageSliderCell.swift
//  IUCA Tour
//
//  Created by User on 1/16/22.
//

import UIKit
import SDWebImage

class ImageSliderCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill

//        iv.image = #imageLiteral(resourceName: "SD")
        
        return iv
    }()
    
    private let loadingIndicator: ProgressView = {
        let progressView = ProgressView(colors: [.iucaBlue], lineWidth: 3)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    var currentURL: String! {
        didSet {
            
            imageView.sd_setImage(with: URL(string: currentURL), completed: { _,_,_,_ in
                self.loadingIndicator.isAnimating = false
            })
        }
    }
    
    var amountOfImages: Int! {
        didSet {
            pageControl.isUserInteractionEnabled = false
            pageControl.numberOfPages = amountOfImages
        }
    }
    
    var currentPage: Int! {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        
        return pc
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        addSubview(imageView)
        imageView.addConstraintsToFillView(self)
        
        addSubview(loadingIndicator)
        loadingIndicator.setDimensions(width: 50, height: 50)
        loadingIndicator.center(inView: self)
        
        loadingIndicator.isAnimating = true
        
        addSubview(pageControl)
        pageControl.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 5)
    }
    
    
}
