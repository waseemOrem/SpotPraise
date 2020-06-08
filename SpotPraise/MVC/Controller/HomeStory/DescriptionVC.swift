//
//  DescriptionVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Alamofire
import Social

class DescriptionVC: BaseViewController {

    //MARK: -Outlets
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUpload: UIImageView!
    
    @IBOutlet weak var tfCompanyName: AnimatableTextField!
    @IBOutlet weak var tfTitle: AnimatableTextField!
    @IBOutlet weak var tVDescription: AnimatableTextView!
    @IBOutlet weak var tfWebsiteName: AnimatableTextField!
    @IBOutlet weak var tfEmailAddress: AnimatableTextField!
    
    //MARK: -Parameters
    private var imagePicker:ImagePicker?;
    private let pickerController = UIImagePickerController();
//    var thumbNailImage:UIImage? = nil
//    var videoURL:URL? = nil
     var socialPostData = [SocialPostDataDictKEYS:Any]()
   // var postUploadedOnServer = false
    var formValidation = ""
     //var uploadChoice:UploadChoices?
    
    
    lazy var postMode:UploadChoices? = {
        
        guard let  tImg =  self.socialPostData[.postMode] as? UploadChoices else {return nil }
        return tImg
    }()
    
    lazy var postThumbNailImage:UIImage? = {
        
        guard let  tImg =  self.socialPostData[.postThumb] as? UIImage else {return nil }
        return tImg
    }()
    
    lazy var postImage:UIImage? = {
        
        guard let  tImg =  self.socialPostData[.postImage] as? UIImage else {return nil }
        return tImg
    }()
    
    lazy var silentPostImage:UIImage? = {
        
       let img = UIImage()
        
        return img
    }()
    
    lazy var postvideoURL:URL? = {
        
        guard let  pURL =  self.socialPostData[.postVideoURL] as? URL else {return nil }
        return pURL
    }()
    
  //  var renderedImage:UIImage?
    

    
    deinit {
        print("")
    }
    //MARK: -ViewDidlpad
    override func viewDidLoad() {
        super.viewDidLoad()
        tfCompanyName.text = ModelDataHolder.shared.loggedData?.companyName ?? ""
        tfCompanyName.isUserInteractionEnabled = false
        tfEmailAddress.isUserInteractionEnabled = false
        tfEmailAddress.text = ModelDataHolder.shared.loggedData?.email ?? ""
        imgUpload.isUserInteractionEnabled = true
        imgUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadLogo)))
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        print(self.socialPostData)
        // Do any additional setup after loading the view.
    }
    
   @objc func uploadLogo(){
        self.imagePicker?.present(from: self.view)
    }
    
    @IBAction func btnActionUpload(_ sender: UIButton) {
        let toValidate = Validation.Validate
        toValidate.delegate = self
        
        if imgUpload.image !=   #imageLiteral(resourceName: "upload_logo"){
                        guard
                            toValidate.validateForEmpty(validatedObj: tfTitle, forInvalid: "Please enter the title."),
                            toValidate.validateForEmpty(validatedObj: tVDescription, forInvalid: "Please enter the description"),
                            toValidate.validateForEmpty(validatedObj: tfEmailAddress, forInvalid: "Please enter a correct email"),
                            toValidate.validateURL(tfWebsiteName, forInvalid: "Please enter correct website."),
                            toValidate.validateForEmail(tfEmailAddress, forInvalid: "Please enter a correct email")
                            else {
                                return
                        }
           
            
            if postMode == .UploadImage{
                //Here we authenticate the form so we have what we needed now we will create a post image
                //UNDER TEST
                guard let silentView = Bundle.main.loadNibNamed("SilentImagineryView", owner: self, options: nil)?.first else { return }
                let silentV = silentView as? SilentImagineryView
                silentV?.frame = (self.view?.frame) ?? CGRect.init(x: 0, y: 0, width: /self.view?.frame.width, height: /self.view?.frame.height)
                silentV?.finalPostImage?.image = self.postImage
                silentV?.logoImageToRender?.image = self.imgUpload.image
                
                
                let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
                let image = renderer.image { ctx in
                    silentV?.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
                }
                
                // self.imgSilent?.isHidden = false
                //self.imgSilent?.image = image
                self.silentPostImage = image
                // self.view.addSubview(silentV!)
                
                postImageToServer()
            }else {
                postVideo()
            }
        }else {
            Alert.shared.showSimpleAlert(_title: "Error".localized, messageStr: "Please add logo")
        }
        
//        let toCompare = (tfTitle?.text)! + (tVDescription?.text)! + (tfWebsiteName?.text)!
//        if self.formValidation == toCompare  && toCompare.count > 0 {
//            self.openPostMediaPopUp()
//        }else {
//         self.formValidation = (tfTitle?.text)! + (tVDescription?.text)! + (tfWebsiteName?.text)!
//
//
//        }
        
    }
    
    @IBAction func btnActionPower(_ sender: UIButton) {
        guard let vc = self.getVC(withId: VC.PostVideoPOPVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PostVideoPOPVC else {
            return
        }
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        self.navigationController?.present(vc, animated: true, completion: nil)
    //  AppManager.Manager.logoutFromApp(fromVc: self)
    }
    
    func postImageToServer(){ ///"thumbnail":"", "video":""
        let params = ["company_title":self.tfTitle.text!,
                      "description":self.tVDescription.text,
                      "email":self.tfEmailAddress.text!,
                      "web_link":tfWebsiteName.text!,
                      "post_image":"",
                      "logo_image":"",
                      
        ] as [String:Any]
        //guard let postImage = self.socialPostData[.postImage] as? UIImage else {return}
        
        let imageParams = ["post_image":postImage,
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
                                                                //Alert.shared.showSimpleAlert(messageStr: mm)
                                                                
                                                                Alert.shared.showAlertWithCompletion(buttons: ["Post on social apps"], msg: "", success: {[weak self] pst in
                                                                    
                                                                    if pst == "Post on social apps"{
                                                                               self?.openPostMediaPopUp()
                                                                    }
                                                                    
                                                                })
                                                                
                                                            })
                     
                                                            
        })
    }
    
    func postVideo(){//"post_image":"",
//      /  let params = ["company_title":"WAseem",
//                      "description":"des",
//                      "email":"lalitattri.orem@gmail.com",
//                      "web_link":"www.google.com",
//                       "post_image":"",
//                      "logo_image":"",
//                      "thumbnail":"",
//                      "video":""]
        let params = ["company_title":self.tfTitle.text!,
                      "description":self.tVDescription.text,
                      "email":self.tfEmailAddress.text!,
                      "web_link":tfWebsiteName.text!,
                      "post_image":"",
                      "logo_image":"",
                      "thumbnail":"",
                                        "video":""
                      
                      ] as [String:Any]
       // guard let thumbNailImage = self.socialPostData[.postThumb] as? UIImage else {return}
       // guard let videoURL = self.socialPostData[.postVideoURL] as? URL else {return}
        
        APIManager.requestWebServerWithAlamoToUploadVideo(to: .addPost,
                                                          VideoUrl: postvideoURL!,
                                                          postImge: self.imgUpload.image,
                                                          imagethumbnel: self.postThumbNailImage!,parameters:params as [String : AnyObject], completion: {response in
            
            APIManager.getJsonDict(response: response, completion: { cleanDict in
              //  postUploadedOnServer = true
                var mm = "Post Added successfully."
                if let msg = cleanDict["msg"] as? String {
                    mm = msg
                }
                Alert.shared.showSimpleAlert(_title: "Alert".localized, messageStr: mm)
                
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

extension DescriptionVC:SocialAppListener{
    
    func openPostMediaPopUp(){
        guard let vc = self.getVC(withId: VC.PostVideoPOPVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PostVideoPOPVC else {
            return
        }
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    func userSelectedApp(preferedApp: SocialApps) {
       
         switch preferedApp {
        case .FaceBook: openFB()
        case .Youtube:break
              case .Twitter:openTwitter()
              case .Linked:break
        case .Instagram:openInsta()
        default:
            break
        }
    }
    
    func openInsta(){
       
        //First we wiil check weather user has choosen image or view
        // UploadImage , UploadVideo
        if postMode == .UploadImage{
              SocialPostManager.sharedManager.postImageToInstaStoryV2(sharingImageView: self.postImage,
                                                                      instagramCaption:tVDescription.text, view: self.view)
        }
        else if  postMode == .UploadVideo{
            
            if self.postvideoURL != nil {
                guard let videData = NSData(contentsOf: self.postvideoURL!) else {
                    return
                }
                
                guard let imageData = self.postImage?.pngData() else { return }
                
               SocialPostManager.sharedManager.shareVideoToInstagramV2(videoData: videData,
                                                                       imageData: imageData as NSData,
                                                                       caption: tVDescription.text)
            }
            
            
            
        }
        
      
        //  SocialPostManager.sharedManager.postImageToInstaStoryV1(imageInstagram: self.imgThumb.image!, instagramCaption: txtV.text, view: self.view)
   
  //  SocialPostManager.sharedManager.shareVideoToInstagramV2(videoData: self.videoDataIs, imageData: self.imgDataIs, caption: "Hello test caption")
        
       // InstagramManager.sharedManager.postImageToInstaStory(sharingImageView: self.postImage,
                                                            // instagramCaption:  "\(self.tVDescription.text)", view: self.view)
       // InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: image!, instagramCaption: "\(self.tVDescription.text)", view: self.view)
    }
    
    func openFB(){
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            if self.postMode == .UploadImage{
                fbShare.add(self.postImage)
            }
            else if self.postMode == .UploadVideo{
                
            }
            fbShare.setInitialText(tVDescription.text)
            //fbShare.add(tfWebsiteName.text)
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openTwitter(){
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            var twShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
             if self.postMode == .UploadImage{
                 twShare.add(self.postThumbNailImage)
            }
            //twShare.
            twShare.setInitialText(tVDescription.text)
            self.present(twShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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

//extension String {
//
//    var canOpenURL : Bool {
//
//        guard let url = NSURL(string: self) else {return false}
//        if !UIApplication.shared.canOpenURL(url as URL) {return false}
//        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
//        return predicate.evaluate(with: self)
//    }
//}


