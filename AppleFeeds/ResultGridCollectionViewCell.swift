//
//  ResultGridCollectionViewCell.swift
//  AppleFeeds
//
//  Created by Sathish Kumar G on 9/30/20.
//  Copyright © 2020 Sathish Kumar G. All rights reserved.
//

import UIKit

class ResultGridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with feed: Result) {
        title.text = feed.name
        subtitle.text = feed.artistName
        if let imageURL = URL(string: feed.artworkUrl100) {
        //Caching the downloaded image
        albumImage.kf.setImage(with: imageURL)
        }
        dateLabel.text = feed.releaseDate
    }
    

}
