//
//  HomeTableViewCell.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 30.03.22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
