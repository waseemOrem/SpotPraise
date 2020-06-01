//
//  PersonalInfoVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SDWebImage

class PersonalInfoVC: BaseViewController {

    //MARK: -OUtlets
    @IBOutlet weak var imgUser:UIImageView?
    @IBOutlet weak var tfFullName:UITextField?
    @IBOutlet weak var tfEmail:UITextField?
    @IBOutlet weak var tfPhoneNumber:UITextField?
    private var imagePicker:ImagePicker?;
    private let pickerController = UIImagePickerController();
    //MARK: -ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
         self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        tfEmail?.isUserInteractionEnabled = false
        tfPhoneNumber?.isUserInteractionEnabled = false
        imgUser?.isUserInteractionEnabled = true
        imgUser?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnImageUpdate)))
uploadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Custom func
    @objc func tapOnImageUpdate(){
          self.imagePicker?.present(from: self.view)
    }
    func updateData(){
        let p = RegistrationData.CodingKeys.self

        let params = [
            p.name.rawValue:tfFullName!.text!,
            "image":"",
                               "devicetype":"ios",
                               "devicetoken":deviceTokenString
            ] as [String : Any]
        APIManager.requestWebServerWithAlamoToUploadImage(to: .editProfile, imageParameteres: ["image":(imgUser?.image)!], parameters: params as [String : AnyObject],  completion: { response in
           
            
            
            let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
            //  let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
            
            if response.response?.statusCode == 200{
                guard  resData?.data != nil else {
                    Alert.shared.showAlertWithCompletion(buttons: ["Dismiss"], msg: MESSAGES.RESPONSE_ERROR.rawValue, success: {_ in })
                    return}
                Toast.show(message: resData?.msg ?? "Updated", controller: self)
                AppManager.Manager.saveLoggedData(registrationData: resData)
                
            }
            
        })
    }
    func uploadData(){
        
        guard let userData = ModelDataHolder.shared.loggedData else {
            return
        }
        console(userData)
        if let logoLink = userData.image{
            if let logoURL =   MakeURL.generateImageURL(imageEndPoint: logoLink)  {
                imgUser?.sd_setImage(with: logoURL , placeholderImage: #imageLiteral(resourceName: "upload_logo"))
            }
        }
        
        
        
        self.tfFullName?.text = userData.name
        self.tfEmail?.text = userData.email
        self.tfPhoneNumber?.text =  userData.countryCode! + " " +  userData.phone!
    }
    
    //MARK: -Actions
    @IBAction func btnUpdateProfile(_ sender:UIButton){
     updateData()
    }

    
}



//MARK:  ImagePickerDelegate

extension PersonalInfoVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            self.imgUser?.image = image
             self.dismiss(animated: true , completion: nil)
            
            //imageData =   self.imgProfile.image?.jpegData(compressionQuality: 0.5)
        }
        
    }
}
