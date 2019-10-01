//
//  ActivityTableViewCell.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 1/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

   
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
