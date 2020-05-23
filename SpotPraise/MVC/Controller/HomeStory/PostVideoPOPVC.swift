//
//  PostVideoPOPVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PostVideoPOPVC: UIViewController {
    weak var delegate:UploadPopUpListner?
    var userChoice:UploadChoices?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnCancelClick(_ sender: UIButton) {
        self.dismiss(animated: true , completion: nil)
    }
    
    @IBAction func btnClickPost(_ sender: UIButton) {
    }
    
    @IBAction func btnPostSocialClick(_ sender: UIButton) {
        
        
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
