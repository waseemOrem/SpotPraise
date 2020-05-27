//
//  DescriptionVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Alamofire

class DescriptionVC: BaseViewController {

    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var imgUpload: UIImageView!
    
    @IBOutlet weak var tfCompanyName: AnimatableTextField!
    
    
    
    
    @IBOutlet weak var tfTitle: AnimatableTextField!
    
    
    @IBOutlet weak var tVDescription: AnimatableTextView!
    
    
    
    @IBOutlet weak var tfWebsiteName: AnimatableTextField!
    
    
    @IBOutlet weak var tfEmailAddress: AnimatableTextField!
    
    private var imagePicker:ImagePicker?;
    private let pickerController = UIImagePickerController();
    var thumbNailImage:UIImage? = nil
    var videoURL:URL? = nil
     var uploadChoice:UploadChoices?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfCompanyName.text = "ok"
        tfCompanyName.isUserInteractionEnabled = false
        imgUpload.isUserInteractionEnabled = true
        imgUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadLogo)))
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        // Do any additional setup after loading the view.
    }
    
   @objc func uploadLogo(){
        self.imagePicker?.present(from: self.view)
    }
    
    @IBAction func btnActionUpload(_ sender: UIButton) {
        
//        guard let vc = getVC(withId: VC.PostVideoPOPVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PostVideoPOPVC else {
//            return
//        }
//        vc.delegate = self
//        vc.modalPresentationStyle = .overFullScreen
//        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.70)
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
        let toValidate = Validation.Validate
        toValidate.delegate = self
      
        if imgUpload.image !=   #imageLiteral(resourceName: "upload_logo"){
            guard  toValidate.validateForEmpty(validatedObj: tfCompanyName, forInvalid: "Please enter company name."),
                toValidate.validateForEmpty(validatedObj: tfTitle, forInvalid: "Please enter the title."),
                toValidate.validateForEmpty(validatedObj: tVDescription, forInvalid: "Please enter the description"),
                toValidate.validateForEmpty(validatedObj: tfEmailAddress, forInvalid: "Please enter a correct email"),
                toValidate.validateForEmail(tfEmailAddress, forInvalid: "Please enter a coreect email")
                else {
                    return
            }
            
            if uploadChoice == .UploadImage{
                postImage()
            }else {
                postVideo()
            }
        }else {
            Alert.shared.showSimpleAlert(messageStr: "Please add logo")
        }
        
       
        
    }
    
    @IBAction func btnActionPower(_ sender: UIButton) {
        
        AppManager.Manager.logoutFromApp(fromVc: self)
    }
    
    func postImage(){ ///"thumbnail":"", "video":""
        let params = ["company_title":self.tfTitle.text!,
                      "description":self.tVDescription.text,
                      "email":self.tfEmailAddress.text!,
                      "web_link":tfWebsiteName.text!,
                      "post_image":"",
                      "logo_image":"",
                      
        ] as [String:Any]
        
        let imageParams = ["post_image":thumbNailImage,
                           "logo_image":self.imgUpload.image]
        
        APIManager.requestWebServerWithAlamoToUploadImage(to: .addPost,
                                                          imageParameteres: imageParams as? [String : UIImage],
                                                          parameters: params as [String : AnyObject],
                                                          completion: {response in
                                                            APIManager.getJsonDict(response: response, completion: {cleanDict in
                                                                var mm = "Post Added successfully."
                                                                if let msg = cleanDict["msg"] as? String {
                                                                   mm = msg
                                                                }
                                                                Alert.shared.showSimpleAlert(messageStr: mm)
                                                                
                                                            })
                     
                                                            
        })
    }
    
    func postVideo(){//"post_image":"",
        let params = ["company_title":"WAseem",
                      "description":"des",
                      "email":"lalitattri.orem@gmail.com",
                      "web_link":"www.google.com",
                       "post_image":"",
                      "logo_image":"",
                      "thumbnail":"",
                      "video":""]
        APIManager.requestWebServerWithAlamoToUploadVideo(to: .addPost, VideoUrl: videoURL!, postImge: self.imgUpload.image, imagethumbnel: thumbNailImage!,parameters:params as [String : AnyObject], completion: {response in
            
            APIManager.getJsonDict(response: response, completion: { cleanDict in
            
                var mm = "Post Added successfully."
                if let msg = cleanDict["msg"] as? String {
                    mm = msg
                }
                Alert.shared.showSimpleAlert(messageStr: mm)
                
            })
            
            })
    }

}

extension DescriptionVC : validationListner{
    func unableToValidate(validationCandidate: AnyObject?, message: String) {
        
        Alert.shared.showAlertWithCompletion(buttons: ["ok"], msg: message, success: {ok in
            
            if let field = validationCandidate as? UITextField {
                field.becomeFirstResponder()
            }
            else if let  field = validationCandidate as? UITextView {
                field.becomeFirstResponder()
            }
        })
        
       
    }
    
   
    
    
}


//MARK:  ImagePickerDelegate

extension DescriptionVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            self.imgUpload.image = image
            
            self.dismiss(animated: true , completion: nil)
           
            //imageData =   self.imgProfile.image?.jpegData(compressionQuality: 0.5)
        }
        
    }
}
