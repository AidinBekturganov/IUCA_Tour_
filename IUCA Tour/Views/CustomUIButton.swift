//
//  CustomUIButton.swift
//  IUCA Tour
//
//  Created by User on 1/8/22.
//

import UIKit

class CustomUIButton: UIButton {
    //MARK: - Properties
    
    private let labelForButton: UILabel = {
        let label = UILabel()
        
        label.text = "Язык"
        label.font = UIFont(name: "Roboto-Regular", size: 10)
        label.textColor = .white
        
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(labelForButton)
//        labelForButton.centerX(inView: self, topAnchor: bottomAnchor, paddingTop: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK
}
