//
//  PostHistoryTableCell.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SDWebImage

enum Actions {
    case REPOST , VIEW_DETAILS
}
protocol cellButtonTapped :AnyObject{
    func onCellButtonClicked(cellActions:Actions,index:IndexPath)
}

class PostHistoryTableCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView?
     @IBOutlet weak var bgImage: UIImageView?
    @IBOutlet weak var lblDescription: UILabel?
    
    
    @IBOutlet weak var lblAddress: UILabel?
    @IBOutlet weak var lblCompanyName: UILabel?
    @IBOutlet weak var lblUserName: UILabel?
    
    var indexP:IndexPath?
    weak var delegate:cellButtonTapped?
    @IBAction func btnReportClick(_ sender: AnimatableButton) {
        delegate?.onCellButtonClicked(cellActions: .REPOST, index: indexP!)
    }
    
    var item:PostHistoryData?{
        
        didSet{
            if let logoLink = item?.logoImage{
                if let logoURL =   URL(string: logoLink)  {
                    imgLogo?.sd_setImage(with: logoURL , placeholderImage: #imageLiteral(resourceName: "upload_logo"))
                }
            }
            
            if item?.thumbnail == "" {
                if let logoLink = item?.postImage{
                    if let logoURL =   URL(string: logoLink)  {
                        bgImage?.sd_setImage(with: logoURL , placeholderImage: #imageLiteral(resourceName: "upload_logo"))
                    }
                }
            }else {
                if let logoLink = item?.thumbnail{
                    if let logoURL =   URL(string: logoLink)  {
                        bgImage?.sd_setImage(with: logoURL , placeholderImage: #imageLiteral(resourceName: "upload_logo"))
                    }
                }
            }
           
            
           lblDescription?.text = item?.descriptionField ?? ""
           lblAddress?.text =  item?.companyTitle ?? ""
            
        }
    }
    
    @IBAction func btnViewDeailClick(_ sender: AnimatableButton) {
        delegate?.onCellButtonClicked(cellActions: .VIEW_DETAILS, index: indexP!)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guard let uName = ModelDataHolder.shared.loggedData?.name  else {
            return
        }
        self.lblUserName?.text = uName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
