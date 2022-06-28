//
//  PlacesListViewCell.swift
//  IUCA Tour
//
//  Created by User on 2/1/22.
//

import UIKit

class PlacesListViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let labelForPlace: UILabel = {
        let label = UILabel()
        label.textColor = .black

        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        
        
        
        return iv
    }()
    
    private let viewForImage: UIView = {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: 28, height: 28)

        
        return view
    }()
    
    var text: String! {
        didSet {
            print("DEBUG: Passed data succesfully \(text)")

            labelForPlace.text = text
        }
    }
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
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
        
        viewForImage.addSubview(imageView)
        imageView.center(inView: viewForImage)
        
        addSubview(viewForImage)

        viewForImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 30)
        
       
        
        addSubview(labelForPlace)
        labelForPlace.centerY(inView: self, leftAnchor: viewForImage.rightAnchor, paddingLeft: 30)
    }
    
    
}
