//
//  ChangePssVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ChangePssVC: UIViewController {

    @IBOutlet weak var tfCurrentPass:AnimatableTextField?
    
    @IBOutlet weak var tfNewPass:AnimatableTextField?
    
    @IBOutlet weak var tfConfirmPass:AnimatableTextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPowerClick(){
        
    }
    @IBAction func btnDoneClick(){
        
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
