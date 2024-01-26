//
//  FeedCell.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Süleyman Ayyılmaz on 20.01.2024.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var postİmageView: UIImageView!
    
    @IBOutlet weak var yorumText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
