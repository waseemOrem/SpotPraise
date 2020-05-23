//
//  ProfileVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {

    @IBOutlet weak var imgUser: UIImageView!
    
    enum MenuItems: String, CaseIterable {
        case personalInfo = "Personal Information"
        case postHistory = "Post History"
        case subscriptionPlan = "Subscription Plan"
        case changePassword = "Change Password"
        
        
        
        init?(id : Int) {
            switch id {
            case 1: self = .personalInfo
            case 2: self = .postHistory
            case 3: self = .subscriptionPlan
            case 4: self = .changePassword
           
                
            default: return nil
            }
        }
    }
    let menuItemsArray = MenuItems.allCases
    override func viewDidLoad() {
        super.viewDidLoad()
self.tableView?.dataSource = self
        self.tableView?.delegate = self
       // r.[0].Pipe
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnPowerClick(_ sender: UIButton) {
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

extension ProfileVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell") as? ProfileTableCell//
       
         let item = menuItemsArray[indexPath.row]
        cell?.lblItem?.text = item.rawValue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let item = menuItemsArray[indexPath.row]
        switch item {
        case .personalInfo:
            
            guard let vc = self.getVC(withId: VC.PersonalInfoVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PersonalInfoVC else {
                return
            }
            self.pushVC(vc)

        case .postHistory:
            guard let vc = self.getVC(withId: VC.PostHistoryVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PostHistoryVC else {
                return
            }
            self.pushVC(vc)
            
        case .subscriptionPlan:
            guard let vc = self.getVC(withId: VC.SubscriptionVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? SubscriptionVC else {
                return
            }
            self.pushVC(vc)
            
        case .changePassword:
            guard let vc = self.getVC(withId: VC.ChangePssVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? ChangePssVC else {
                return
            }
            self.pushVC(vc)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
