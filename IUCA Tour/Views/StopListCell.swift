//
//  StopListCell.swift
//  IUCA Tour
//
//  Created by User on 1/16/22.
//

import UIKit

class StopListCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let labelForPlace: UILabel = {
        let label = UILabel()
        label.textColor = .black

        label.font = UIFont(name: "Roboto-Regular", size: 16)
        
        return label
    }()
    
    var text: String! {
        didSet {
            labelForPlace.text = text
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
        
        addSubview(labelForPlace)
        labelForPlace.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 17)
    }
    
    
}
