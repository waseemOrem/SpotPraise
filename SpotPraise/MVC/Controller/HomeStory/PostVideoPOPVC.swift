//
//  PostVideoPOPVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PostVideoPOPVC: UIViewController {
    weak var delegate:SocialAppListener?
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
        self.dismiss(animated: true , completion: nil)
        switch sender.tag {
        case 1:
            delegate?.userSelectedApp(preferedApp: .FaceBook)
        case 2:
            delegate?.userSelectedApp(preferedApp: .Instagram)
        case 3:
            delegate?.userSelectedApp(preferedApp: .Twitter)
        case 4:
            delegate?.userSelectedApp(preferedApp: .Linked)
        case 5:
            delegate?.userSelectedApp(preferedApp: .Youtube)
        default:
            break
        }
        
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
