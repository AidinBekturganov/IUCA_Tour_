//
//  MenuVIew.swift
//  IUCA Tour
//
//  Created by User on 1/19/22.
//

import UIKit

class MenuView: UIView {

    // MARK: - Properties
    
    var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Selectors
    
    // MARK: - Helpers

    func configureUI() {
        backgroundColor = .white
    }
    
}
