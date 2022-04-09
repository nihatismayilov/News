//
//  SavedTableViewCell.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 30.03.22.
//

import UIKit

class SavedTableViewCell: UITableViewCell {

    @IBOutlet var savedTopicLabel: UILabel!
    @IBOutlet var savedTitleLabel: UILabel!
    @IBOutlet var savedDateLabel: UILabel!
    @IBOutlet var savedAuthorLabel: UILabel!
    @IBOutlet var savedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
