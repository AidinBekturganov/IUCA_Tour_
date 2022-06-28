//
//  CustomNavigationBar.swift
//  IUCA Tour
//
//  Created by User on 1/19/22.
//

import UIKit

class CustomNavigationBar: UIView {

    // MARK: - Properties
    
    private var title: String
    private var leftBarButton: UIButton
    private var rightBarButton: UIButton
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        
        return label
    }()

    // MARK: - Lifecycle
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//
//    }
    
    required init(title: String?, leftBarButton: UIButton?, rightBarButton: UIButton?) {
        self.title = title ?? ""
        self.leftBarButton = leftBarButton ?? UIButton()
        self.rightBarButton = rightBarButton ?? UIButton()
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Selectors
    
    // MARK: - Helpers

    func configureUI() {
        backgroundColor = .iucaBlue
        
        addSubview(leftBarButton)
        leftBarButton.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 17, paddingBottom: 17)
        
        addSubview(rightBarButton)
        rightBarButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 17, paddingRight: 17)
        
        headerLabel.text = title
        addSubview(headerLabel)
        headerLabel.centerX(inView: self, bottomAnchor: bottomAnchor, paddingBottom: 14)
        
        
    }
    
}
