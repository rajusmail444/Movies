//
//  LoadingIndicatorView.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import UIKit

class LoadingIndicatorView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: LoadingIndicatorView.self)
    }
    
    var activityIndicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 50))
        view.style = .medium
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
        ])
        addSubview(activityIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
