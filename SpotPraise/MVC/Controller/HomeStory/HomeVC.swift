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
    
    
    //MARK: -Parameters
    lazy var  imageV:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
        }()
    
    lazy var postButton:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
       
        return btn
    }()
    lazy var cancelPreviewButton:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    lazy var postThumbNailHolder:UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    var socialPostData = [SocialPostDataDictKEYS:Any]()
    var choosenPrefrence:UploadChoices?
  
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
lblUserName?.text = ModelDataHolder.shared.loggedData?.username ?? ""
        
       
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Actions
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
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
 
}

extension HomeVC {
    //MARK :-Custom functions
    @objc func clickedOnCancelPreview(){
        self.postThumbNailHolder.removeFromSuperview()
    }
    @objc func clickedOnAddPost(){
        
        guard let vc = getVC(withId: VC.DescriptionVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? DescriptionVC else {
            return
        }
        
//        guard let thumNailImg = self.postData[postThumb.rawValue] as? UIImage else {
//            return
//        }
//        if choosenPrefrence == .UploadVideo{
//            guard let videoURL = self.postData[PostDataDict.postVideo.rawValue] as? URL  else {
//                return
//            }
//          vc.videoURL = videoURL
//        }
        vc.socialPostData = self.socialPostData
        //vc.uploadChoice = self.choosenPrefrence
       // vc.thumbNailImage = thumNailImg
        
        self.navigationController?.pushViewController(vc, animated: true)
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
             self.imageV.image = data[.postImage] as? UIImage
            
        case .UploadVideo:
            guard let data = dataSource as? [SocialPostDataDictKEYS:Any] else {
                return
            }
            self.socialPostData = data
             self.imageV.image = data[.postThumb] as? UIImage
          
        default:
            break
        }
        
        print(self.socialPostData)
        addPreview()
        
        
    }
    
}
//MARK: -PREVIEW ADDITION
extension HomeVC{
    
    func addPreview(){
        self.viewHolder?.addSubview(postThumbNailHolder)
        postThumbNailHolder.leadingAnchor.constraint(equalTo: (self.viewHolder?.leadingAnchor)!).isActive = true
        postThumbNailHolder.trailingAnchor.constraint(equalTo: (self.viewHolder?.trailingAnchor)!).isActive = true
        postThumbNailHolder.topAnchor.constraint(equalTo: (self.viewHolder?.topAnchor)!).isActive = true
        postThumbNailHolder.bottomAnchor.constraint(equalTo: (self.viewHolder?.bottomAnchor)!).isActive = true
        
        self.postThumbNailHolder.addSubview(imageV)
        
        //self.viewHolder!.bringSubviewToFront(self.view!)
        imageV.leadingAnchor.constraint(equalTo: (self.viewHolder?.leadingAnchor)!).isActive = true
        imageV.trailingAnchor.constraint(equalTo: (self.viewHolder?.trailingAnchor)!).isActive = true
        imageV.topAnchor.constraint(equalTo: (self.viewHolder?.topAnchor)!).isActive = true
        imageV.bottomAnchor.constraint(equalTo: (self.viewHolder?.bottomAnchor)!).isActive = true
        imageV.backgroundColor = .red
        imageV.isUserInteractionEnabled = true
        
        self.imageV.addSubview(postButton)
        postButton.heightAnchor.constraint(equalToConstant: 110).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        postButton.bottomAnchor.constraint(equalTo: (viewHolder?.bottomAnchor)!).isActive = true
        postButton.centerXAnchor.constraint(equalTo: imageV.centerXAnchor).isActive = true
        postButton.setBackgroundImage(#imageLiteral(resourceName: "ic_home_circle_button"), for: .normal)
        
        postButton.addTarget(self, action: #selector(clickedOnAddPost), for: .touchUpInside)
        
        
        self.imageV.addSubview(cancelPreviewButton)
        cancelPreviewButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelPreviewButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cancelPreviewButton.topAnchor.constraint(equalTo: (viewHolder?.topAnchor)!, constant: 5).isActive = true
       cancelPreviewButton.leadingAnchor.constraint(equalTo: (viewHolder?.leadingAnchor)!, constant: 5).isActive = true
       // postButton.centerXAnchor.constraint(equalTo: imageV.centerXAnchor).isActive = true
        cancelPreviewButton.backgroundColor = .clear
        cancelPreviewButton.layer.borderWidth = 1
        cancelPreviewButton.layer.borderColor = UIColor.darkGray.cgColor
        let img = UIImageView()
        self.imageV.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 25).isActive = true
        img.widthAnchor.constraint(equalToConstant: 25).isActive = true
        img.image = #imageLiteral(resourceName: "ic_cross")
        img.centerXAnchor.constraint(equalTo: cancelPreviewButton.centerXAnchor).isActive = true
         img.centerYAnchor.constraint(equalTo: cancelPreviewButton.centerYAnchor).isActive = true
        
        //cancelPreviewButton.setBackgroundImage(img.image, for: .normal)
        
         cancelPreviewButton.addTarget(self, action: #selector(clickedOnCancelPreview), for: .touchUpInside)
        
        
    }
}


