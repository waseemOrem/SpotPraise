//
//  HomeVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Alamofire

enum SocialPostDataDictKEYS:String {
    case postMode = "postMode"
    case postThumb = "postThumb"
    case postImage = "postImage"
    case postVideoURL = "postVideoURL"
    
}
class HomeVC: BaseViewController {

    //MARK: -Outlets
    @IBOutlet weak var viewHolder:UIView?
     @IBOutlet weak var lblUserName:UILabel?
     //MARK: - UPDATED 19 june
    @IBOutlet weak var preViewImage: UIImageView?
    @IBOutlet weak var viewPreview: UIView?
    
    
    //MARK: -Parameters
    
    var socialPostData = [SocialPostDataDictKEYS:Any]()
    var choosenPrefrence:UploadChoices?
  
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
          lblUserName?.text = ModelDataHolder.shared.loggedData?.username ?? ""
        
        //MARK: - UPDATED 19 june
        viewPreview?.isHidden = true
     }
    
    //MARK: -Actions
    //MARK: - UPDATED 19 june
    @IBAction func btnMoveToPostClick(_ sender: UIButton) {
        guard let vc = getVC(withId: VC.DescriptionVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? DescriptionVC else {
            return
        }
        
        vc.socialPostData = self.socialPostData
        self.navigationController?.pushViewController(vc, animated: true)
    }
   @IBAction func preViewRemoveClick(_ sender: UIButton) {
        viewPreview?.isHidden = true
    }
    //End
    
    
    
    @IBAction func btnProfileClick(_ sender: UIButton) {
       
        //Toast.show(message: "Login again", controller: nil)
        //AppManager.Manager.logoutFromApp(fromVc: nil, priorityOfLogout: .High)
        guard let vc = getVC(withId: VC.ProfileVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? ProfileVC else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnUploadClick(){
//        imageV.image = #imageLiteral(resourceName: "splash")
//        addPreview()
        
        guard let vc = getVC(withId: VC.UploadVideoPopUpVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? UploadVideoPopUpVC else {
            return
        }
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
 
}


//MARK: DELEGATES

//MARK: -UploadPopUpListner
extension HomeVC:UploadPopUpListner{
    
    func didTappedOnDone(prefrence: UploadChoices, dataSource: Any?) {
        //print(prefrence)
        choosenPrefrence = prefrence
        switch prefrence {
        case .UploadImage:
            guard let data = dataSource as? [SocialPostDataDictKEYS:Any] else {
                return
            }
            self.socialPostData = data
           //MARK: - UPDATED 19 june
           preViewImage?.image = data[.postImage] as? UIImage
            
        case .UploadVideo:
            guard let data = dataSource as? [SocialPostDataDictKEYS:Any] else {
                return
            }
            self.socialPostData = data
            //MARK: - UPDATED 19 june
            preViewImage?.image = data[.postImage] as? UIImage
          
        default:
            break
        }
        
        print(self.socialPostData)
        guard let data = dataSource as? [SocialPostDataDictKEYS:Any] else {
            return
        }
        
        
        //ptional(<UIImage: 0x600002ce5880> size {1125, 840} orientation 0 scale 1.000000)
      //  DispatchQueue.main.async {
      //  self.imageV.image = #imageLiteral(resourceName: "splash")
            self.addPreview()
      //  }
       
        
        
    }
    
}
//MARK: -PREVIEW ADDITION
extension HomeVC{
    //MARK: - UPDATED 19 june
    func addPreview(){
        viewPreview?.isHidden = false
    }

    
}


