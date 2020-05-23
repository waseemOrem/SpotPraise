//
//  HomeVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {

    //MARK: -Outlets
    @IBOutlet weak var viewHolder:UIView?
    
    
    //MARK: -Parameters
    lazy var  imageV:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
        }()
    
    lazy var postButton:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
       
        return btn
    }()
    
    lazy var postThumbNailHolder:UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
  
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @objc func clickedOnAddPost(){
        
        guard let vc = getVC(withId: VC.DescriptionVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? DescriptionVC else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: DELEGATES

//MARK: -UploadPopUpListner
extension HomeVC:UploadPopUpListner{
    
    func didTappedOnDone(prefrence: UploadChoices, dataSource: Any?) {
        //print(prefrence)
        switch prefrence {
        case .UploadImage:
            guard let img = dataSource as? UIImage else {
                return
            }
            self.imageV.image = img
            
        default:
            break
        }
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
        postButton.heightAnchor.constraint(equalToConstant: 130).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        postButton.bottomAnchor.constraint(equalTo: (viewHolder?.bottomAnchor)!).isActive = true
        postButton.centerXAnchor.constraint(equalTo: imageV.centerXAnchor).isActive = true
        postButton.setImage(#imageLiteral(resourceName: "ic_home_circle_button"), for: .normal)
        
        postButton.addTarget(self, action: #selector(clickedOnAddPost), for: .touchUpInside)
    }
}
