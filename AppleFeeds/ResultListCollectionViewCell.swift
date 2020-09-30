//
//  ResultListCollectionViewCell.swift
//  AppleFeeds
//
//  Created by Sathish Kumar G on 9/30/20.
//  Copyright © 2020 Sathish Kumar G. All rights reserved.
//

import UIKit
import Kingfisher

class ResultListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImage.image = nil
        title.text = ""
        subtitle.text = ""
        dateLabel.text = ""
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.sizeToFit()
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = UIFont.systemFont(ofSize: 20)
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.numberOfLines = 0
        subtitle.sizeToFit()
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.numberOfLines = 0
        dateLabel.sizeToFit()
    }
    
    func setup(with feed: Result) {
        title.text = feed.name
        subtitle.text = feed.artistName
        if let imageURL = URL(string: feed.artworkUrl100) {
            albumImage.kf.setImage(with: imageURL)
        }
        dateLabel.text = feed.releaseDate
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImage.image = nil
        title.text = ""
        subtitle.text = ""
        dateLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
