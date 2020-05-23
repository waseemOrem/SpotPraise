//
//  HomeVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
//UploadVideoPopUpVC
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPowerClick(_ sender: UIButton) {
    }
    @IBAction func btnProfileClick(_ sender: UIButton) {
        guard let vc = getVC(withId: VC.ProfileVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? ProfileVC else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnUploadClick(){
        guard let vc = getVC(withId: VC.UploadVideoPopUpVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? UploadVideoPopUpVC else {
            return
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        self.navigationController?.present(vc, animated: true, completion: nil)
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
