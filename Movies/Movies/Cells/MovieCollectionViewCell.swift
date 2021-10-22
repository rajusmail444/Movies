//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            imageView.load(url: URL(string: movie?.poster ?? "")!)
            titleLabel.text = movie?.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .systemGray6
        contentView.cornerRadius = 10
    }
}

