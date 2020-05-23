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
        
        guard let vc = getVC(withId: VC.PostVideoPOPVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PostVideoPOPVC else {
            return
        }
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnActionPower(_ sender: UIButton) {
        Alert.shared.showAlertWithCompletion(buttons: ["logout","dismiss"], msg: "Are you sure to logout?", success: { [weak self]
            
                decision in
            
            if decision == "logout"{
               AppManager.Manager.initStoryBoard(type: .Login)
               // for vc in  AppManager.Manager.customStackTree.enumerated() 
               // self?.navigationController?.popToRootViewController(animated: true)
            }
            
        })
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

extension DescriptionVC : UploadPopUpListner{
    func didTappedOnDone(prefrence: UploadChoices, dataSource: Any?) {
        
    }
    
    
}
