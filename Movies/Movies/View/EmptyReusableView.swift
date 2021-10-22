//
//  SectionHeaderReusableView.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import UIKit

class EmptyReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: EmptyReusableView.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: .zero)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

