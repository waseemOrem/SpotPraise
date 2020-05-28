//
//  UploadVideoPopUpVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation
import MediaPlayer
import MobileCoreServices
//import SDWebImage
import MobileCoreServices
import AssetsLibrary

protocol UploadPopUpListner:AnyObject {
    func didTappedOnDone(prefrence:UploadChoices,dataSource:Any?)
}

protocol SocialAppListener:AnyObject {
    func userSelectedApp(preferedApp:SocialApps)
}

class UploadVideoPopUpVC: UIViewController {

    weak var delegate:UploadPopUpListner?
    var userChoice:UploadChoices?
    private var imagePicker:ImagePicker?;
    private let pickerController = UIImagePickerController();
    var choosenData:Any?
    var mypath:URL? = nil
     var thumbnail = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
  }
    
    @IBAction func btnDoneClick(_ sender: Any) {
      
//        guard userChoice != nil , choosenData != nil else {
//            return
//        }
//
//        self.delegate?.didTappedOnDone(prefrence: userChoice!,dataSource: choosenData)
//        self.dismiss(animated: true , completion: nil)
    }
    @IBAction func btnImgClick(_ sender: UIButton) {
        userChoice = .UploadImage
       // self.imagePicker.m
        self.imagePicker?.present(from: sender)
    }
    @IBAction func btnVideoClick(_ sender: Any) {
         userChoice = .UploadVideo
        Alert.shared.showAlertWithCompletion(buttons: ["Photo library","Camera"], msg: "", success: {  phLibr in
            
            if phLibr == "Photo library" {
                self.openVideoPicker(sourceType: .photoLibrary)
            }else {
                 self.openVideoPicker(sourceType: .camera)
            }
            
        })
       
    }
    @IBAction func btnDismissClick(_ sender: Any) {
         self.dismiss(animated: true , completion: nil)
    }
    
   

}
extension UploadVideoPopUpVC:AVPlayerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func openVideoPicker(sourceType:UIImagePickerController.SourceType){
        
        let videoPickerController = UIImagePickerController()
       // let s = videoPickerController.sourceType
        videoPickerController.sourceType = sourceType
        videoPickerController.mediaTypes = [kUTTypeMovie as String]
        videoPickerController.delegate = self
        videoPickerController.videoMaximumDuration = 10.0
        
        present(videoPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard  let mediaType = info[UIImagePickerController.InfoKey.mediaURL] as? NSString else {
//            return
//            print("no it not")
//        }
       // let url = info[UIImagePickerControllerMediaURL]
        //  print(url!)
    //    if mediaType.isEqual(to: kUTTypeMovie  as String)//
      //  {
        var _videoData = [String:Any]()
        
            let urlOfVideo = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            if urlOfVideo != nil
            {
                mypath = urlOfVideo as URL?
                
                
                // print(mypath!)
                print("we found a video url.. \(mypath)")
                do
                {
                    let asset = AVURLAsset(url: mypath! , options: nil)
                    let durationInSeconds = asset.duration.seconds
                    print("SEC ARE \(durationInSeconds)")
//                    let videoReso = CommonMethods.Manager.getVideoResolution(with: urlOfVideo! as URL)
//
//                    print("is video is 480 p \(videoReso)")
                    
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    thumbnail = UIImage(cgImage: cgImage)
                    _videoData[PostDataDict.postThumb.rawValue] = thumbnail
                    _videoData[PostDataDict.postVideo.rawValue] =  mypath
                    print("Thumbnail image \(thumbnail)")
                    
                }
                catch let error
                {
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
                
                
            }
            
       // }
        self.dismiss(animated: true, completion: nil )
        
        closeVideoPopUp(videoData: _videoData)
    }
    
    func closeVideoPopUp(videoData:[String:Any?]){
        
        
        choosenData = videoData
        guard userChoice != nil , choosenData != nil else {
            return
        }

        self.delegate?.didTappedOnDone(prefrence: userChoice!,dataSource: choosenData)
        choosenData = nil
        
        self.dismiss(animated: true , completion: nil)
        
    }
    
    func openVideoEditor(){
        if UIVideoEditorController.canEditVideo(atPath: (mypath?.absoluteString)!) {
            let editController = UIVideoEditorController()
            editController.videoPath = (mypath?.absoluteString)!
            editController.delegate = self
            present(editController, animated:true)
        }
    }
}

extension UploadVideoPopUpVC: UIVideoEditorControllerDelegate {
    func videoEditorController(_ editor: UIVideoEditorController,
                               didSaveEditedVideoToPath editedVideoPath: String) {
        dismiss(animated:true)
    }
    
    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
        dismiss(animated:true)
    }
    
    func videoEditorController(_ editor: UIVideoEditorController,
                               didFailWithError error: Error) {
        print("an error occurred: \(error.localizedDescription)")
        dismiss(animated:true)
    }
}

//MARK:  ImagePickerDelegate

extension UploadVideoPopUpVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
             var _videoData = [String:Any]()
            
            _videoData[PostDataDict.postThumb.rawValue] = image
            
            choosenData = _videoData
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
