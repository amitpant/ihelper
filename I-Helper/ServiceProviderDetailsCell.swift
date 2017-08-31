//
//  ServiceProviderDetailsCell.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 09/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class ServiceProviderDetailsCell: UITableViewCell {

    @IBOutlet weak var noOfJobDoneLabel: UILabel!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerProfileImage: UIImageView!{
        didSet{
            providerProfileImage.layer.cornerRadius = providerProfileImage.frame.size.width/2
            providerProfileImage.contentMode = .scaleAspectFill
            providerProfileImage.clipsToBounds = true
            providerProfileImage.backgroundColor = .gray
        }
    }
    @IBOutlet weak var ratingControl: RatingControl!
    
    var item: ServiceProviderViewModelAgenciesItem?  {
        didSet {
            self.noOfJobDoneLabel.text = item?.jobDone
            self.providerNameLabel.text = item?.name
            if let imageURL = item?.pictureUrl,let url = NSURL(string: imageURL) as URL?{
                self.providerProfileImage.ap_setImage(url:url )
            }
            if let strRating = item?.rating, let rating = Double(strRating)  {
                 self.ratingControl.rating = Int(rating)
            }
           
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
