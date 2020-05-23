//
//  DescriptionVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class DescriptionVC: BaseViewController {

    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var imgUpload: UIImageView!
    
    @IBOutlet weak var tfCompanyName: AnimatableTextField!
    
    
    
    
    @IBOutlet weak var tfTitle: AnimatableTextField!
    
    
    @IBOutlet weak var tVDescription: AnimatableTextView!
    
    
    
    @IBOutlet weak var tfWebsiteName: AnimatableTextField!
    
    
    @IBOutlet weak var tfEmailAddress: AnimatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActionUpload(_ sender: UIButton) {
    }
    
    @IBAction func btnActionPower(_ sender: UIButton) {
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
