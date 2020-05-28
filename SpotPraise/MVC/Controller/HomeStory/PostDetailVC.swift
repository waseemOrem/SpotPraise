//
//  PostDetailVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SDWebImage

class PostDetailVC: BaseViewController {

    //MARK: -Outlets
     @IBOutlet weak var imgPost: UIImageView?
     @IBOutlet weak var imgLogo: UIImageView?
     @IBOutlet weak var lblName: UILabel?
     @IBOutlet weak var lblCompanyName: UILabel?
     @IBOutlet weak var lblCompanyAdd: UILabel?
     @IBOutlet weak var lblDescription: UILabel?
     @IBOutlet weak var lblWebsite: UILabel?
     @IBOutlet weak var lblEmail: UILabel?
    
    
    
    //MARK: -Parametes
     var postData:PostHistoryData?
    
    
     //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
       
        // Do any additional setup after loading the view.
    }
    

    
    func updateData(){
        if let logoLink = postData?.logoImage{
            if let logoURL =   URL(string: logoLink)  {
                imgLogo?.sd_setImage(with: logoURL , placeholderImage: #imageLiteral(resourceName: "upload_logo"))
            }
        }
        
        if (postData?.video?.isEmpty)!{
            if let logoLink = postData?.postImage{
                
                if let logoURL =   URL(string: logoLink)  {
                    imgPost?.sd_setImage(with: logoURL , placeholderImage: #imageLiteral(resourceName: "upload_logo"))
                }
            }
        }
            
        else if !(postData?.video?.isEmpty)!{
            if let logoLink = postData?.thumbnail{
                
                if let logoURL =   URL(string: logoLink)  {
                    imgPost?.sd_setImage(with: logoURL , placeholderImage: #imageLiteral(resourceName: "upload_logo"))
                }
            }
        }
        
        
        
        
        lblEmail?.text = postData?.email
        lblWebsite?.text = postData?.webLink
        lblName?.text = ModelDataHolder.shared.loggedData?.name
        lblCompanyName?.text = postData?.companyTitle
        lblCompanyAdd?.text = ""
        
        lblDescription?.text = postData?.descriptionField
    }
    //MARK: -Actions
    @IBAction func btnClickRepost(_ sender: UIButton) {
        
        
        
    }
    
}
