//
//  PostDetailVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PostDetailVC: BaseViewController {

    @IBOutlet weak var imgPost: UIImageView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblCompanyName: UILabel!
    
    
    
    @IBOutlet weak var lblCompanyAdd: UILabel!
    
    
    @IBOutlet weak var lblDescription: UILabel!
    
    
    @IBOutlet weak var lblWebsite: UILabel!
    
    
    
    
    @IBOutlet weak var lblEmail: UILabel!
    
    
    
    @IBAction func btnClickReport(_ sender: UIButton) {
    }
    
    @IBAction func btnDetail(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
lblDescription.text = "kjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhjkjhkhjkhj"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
