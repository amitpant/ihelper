//
//  ServiceProviderTableViewCell.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 04/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol ServiceProviderTableViewCellDelegate:class {
    func selProviderIdToJobList(providerID: String, isselected: Bool)
    //func removeProviderIdToJobList(providerID: Int)
    
}

class ServiceProviderTableViewCell: UITableViewCell {

    weak var delegate:ServiceProviderTableViewCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobCountLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
            profileImageView.backgroundColor = .gray
            profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var checkBoxButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkBoxPressed(_ sender: UIButton) {
        checkBoxButton.isSelected = !checkBoxButton.isSelected
        delegate?.selProviderIdToJobList(providerID: String(sender.tag), isselected: checkBoxButton.isSelected)
    }
    
    func configureCell(serviceProvider: ServiceProvider)  {
       self.nameLabel.text = serviceProvider.name
        self.jobCountLabel.text = serviceProvider.job_done
        let rating = Double(serviceProvider.rating as String)!
        self.ratingControl.rating = Int(rating)
        if let providerID = Int(serviceProvider.provider_id) {
            self.checkBoxButton.tag = providerID
        }
        
        if let imageurl = URL(string: serviceProvider.profile_pic) {
            self.profileImageView.ap_setImage(url: imageurl)
        }
    }
    
}
