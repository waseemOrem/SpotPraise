//
//  PostHistoryTableCell.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PostHistoryTableCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView?
    @IBOutlet weak var lblDescription: UILabel?
    
    
    @IBOutlet weak var lblAddress: UILabel?
    @IBOutlet weak var lblCompanyName: UILabel?
    @IBOutlet weak var lblUserName: UILabel?
    
    
    @IBAction func btnReportClick(_ sender: AnimatableButton) {
    }
    
    
    
    @IBAction func btnViewDeailClick(_ sender: AnimatableButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
