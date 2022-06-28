//
//  ImageSlider.swift
//  IUCA Tour
//
//  Created by User on 1/16/22.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "ImageCell"


class ImageSlider: UIView {
    //MARK: - Properties
    var orr = [#imageLiteral(resourceName: "2018-09-28_11-33-21_165537 4"), #imageLiteral(resourceName: "2018-09-28_11-33-21_165537 4"), #imageLiteral(resourceName: "2018-09-28_11-33-21_165537 4"), #imageLiteral(resourceName: "2018-09-28_11-33-21_165537 4")]
    
    lazy var collectionViewForImages: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        cv.bounces = false
        cv.alwaysBounceVertical = false
        
        return cv
    }()
    
    private let swipeRightButton: UIButton = {
        let button = UIButton()
        
        button.setImage(#imageLiteral(resourceName: "Slider 3").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSwipeRightButton), for: .touchUpInside)
        
        return button
    }()
    
    private let swipeLeftButton: UIButton = {
        let button = UIButton()
        
        button.setImage(#imageLiteral(resourceName: "Slider 2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSwipeLeftButton), for: .touchUpInside)
        
        return button
    }()
    
    var imagesArr: [String]? {
        didSet {
            DispatchQueue.main.async {

                self.collectionViewForImages.reloadData()
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func handleSwipeRightButton() {
        
        swipeRightButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(handleEnable), userInfo: nil, repeats: false)
        let visibleItems: NSArray = self.collectionViewForImages.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row != (imagesArr?.count ?? 0) {
            self.collectionViewForImages.scrollToItem(at: nextItem, at: .left, animated: true)
        }
    }
    
   
    @objc func handleSwipeLeftButton() {
    
        let visibleItems: NSArray = self.collectionViewForImages.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        swipeLeftButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(handleEnable), userInfo: nil, repeats: false)
        if nextItem.row != -1 {
            self.collectionViewForImages.scrollToItem(at: nextItem, at: .right, animated: true)
        }
    }
    
    @objc func handleEnable() {
        swipeRightButton.isEnabled = true
        swipeLeftButton.isEnabled = true
    }
    
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
        collectionViewForImages.register(ImageSliderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addSubview(collectionViewForImages)
        collectionViewForImages.addConstraintsToFillView(self)
        
        addSubview(swipeRightButton)
        swipeRightButton.centerY(inView: self, rightAnchor: rightAnchor, paddingRight: 10)
        
        addSubview(swipeLeftButton)
        swipeLeftButton.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 10)
        
        
        //        view.addSubview(collectionViewForImages)
        //        collectionViewForImages.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
        //                                       right: view.rightAnchor, width: view.frame.width, height: view.frame.height / 3.5)
        
        
    }
}


extension ImageSlider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageSliderCell
        cell.currentURL = imagesArr?[indexPath.row] ?? ""
        cell.amountOfImages = imagesArr?.count ?? 0
        cell.currentPage = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return imagesArr?.count ?? 0
    }
    
    
}

extension ImageSlider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension ImageSlider: UICollectionViewDelegate {
    
}
