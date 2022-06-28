//
//  PlacesListView.swift
//  IUCA Tour
//
//  Created by User on 2/1/22.
//

import UIKit

private let reuseIdentifier = "PlacesListCell"


class PlacesListView: UIView {
    //MARK: - Properties
    var orr = ["Прихожая", "Board of Trustees", "Столовая", "Зона отдыха", "Президентский офис", "Зона отдыха", "Президентский офис", "Зона отдыха", "Президентский офис",  "Зона отдыха", "Президентский офис",  "Зона отдыха", "Президентский офис"]
    var images = [#imageLiteral(resourceName: "Vector-4"), #imageLiteral(resourceName: "bmitemcheckbox"), #imageLiteral(resourceName: "Vector-6"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20"), #imageLiteral(resourceName: "Ellipse 20")]
    
  
    
    lazy var collectionViewForPlacesList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.scrollDirection = .vertical
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        cv.bounces = false
        cv.alwaysBounceVertical = false
        return cv
    }()
    
   
    var placesArray: [Place]? {
        didSet {
        }
    }
    
    var currentId: Int? {
        didSet {
            print("DEBUG: THE CURRENT ID IS : \(currentId)")
        }
    }
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        print("DEBUG: Passed data succesfully \(placesArray?.count ?? 0)")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    
    func configureUI() {
        collectionViewForPlacesList.register(PlacesListViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addSubview(collectionViewForPlacesList)
        collectionViewForPlacesList.addConstraintsToFillView(self)
        
       
        
    }
}


extension PlacesListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!  PlacesListViewCell
        cell.text = placesArray?[indexPath.row].name ?? ""
        
        cell.image = #imageLiteral(resourceName: "bmitemcheckbox-1")
        
        if placesArray?[indexPath.row] == placesArray?[currentId ?? 0] {
            cell.image = #imageLiteral(resourceName: "bmitempoint")
        }
        
        if indexPath.row > currentId ?? 0 {
            cell.image = #imageLiteral(resourceName: "Ellipse 20")
        }
        
        
//        cell.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return placesArray?.count ?? 0
    }
    
    
}

extension PlacesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

extension PlacesListView: UICollectionViewDelegate {
    
}
