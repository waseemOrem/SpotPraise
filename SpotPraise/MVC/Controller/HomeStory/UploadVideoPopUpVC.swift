//
//  UploadVideoPopUpVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol UploadPopUpListner:AnyObject {
    func didTappedOnDone(prefrence:UploadChoices,dataSource:Any?)
}

class UploadVideoPopUpVC: UIViewController {

    weak var delegate:UploadPopUpListner?
    var userChoice:UploadChoices?
    private var imagePicker:ImagePicker?;
    private let pickerController = UIImagePickerController();
    var choosenData:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
  }
    
    @IBAction func btnDoneClick(_ sender: Any) {
      
        guard userChoice != nil , choosenData != nil else {
            return
        }
        
        self.delegate?.didTappedOnDone(prefrence: userChoice!,dataSource: choosenData)
        self.dismiss(animated: true , completion: nil)
    }
    @IBAction func btnImgClick(_ sender: UIButton) {
        userChoice = .UploadImage
        self.imagePicker?.present(from: sender)
    }
    @IBAction func btnVideoClick(_ sender: Any) {
         userChoice = .UploadVideo
    }
    @IBAction func btnDismissClick(_ sender: Any) {
         self.dismiss(animated: true , completion: nil)
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

//MARK:  ImagePickerDelegate

extension UploadVideoPopUpVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            choosenData = image
            guard userChoice != nil , choosenData != nil else {
                return
            }
            
            self.delegate?.didTappedOnDone(prefrence: userChoice!,dataSource: choosenData)
            self.dismiss(animated: true , completion: nil)
            choosenData = nil
            //imageData =   self.imgProfile.image?.jpegData(compressionQuality: 0.5)
        }
        
    }
}
