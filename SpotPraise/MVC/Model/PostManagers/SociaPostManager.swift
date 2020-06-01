import UIKit
import Foundation
import Photos
import AssetsLibrary
 


class SocialPostManager: NSObject, UIDocumentInteractionControllerDelegate {
    private let kInstagramURL = "instagram://app"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    var documentInteractionController = UIDocumentInteractionController()
    
    // singleton manager
    class var sharedManager: SocialPostManager {
        struct Singleton {
            static let instance = SocialPostManager()
        }
        return Singleton.instance
    }
    /*
     let url = URL(string: "instagram://library?LocalIdentifier=" + videoLocalIdentifier)
     
     */
    //MARK: -Instagram SHARING
    //IMAGEEEE
    //https://developers.facebook.com/docs/instagram/sharing-to-stories/
    func postImageToInstaStoryV2(sharingImageView:UIImage?,instagramCaption:String, view: UIView){
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let image = sharingImageView else { return }
                guard let imageData = image.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.InstagramCaption":instagramCaption,
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            } else {
                
                UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
                // print("User doesn't have instagram on their device.")
            }
        }
    }
    
    func postImageToInstaStoryV1(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        // called to post image with caption to the instagram application
        
        let instagramURL = NSURL(string: kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
            guard let imgD = imageInstagram.jpegData(compressionQuality: 1.0) else {
                return
            }
            
            do {
                try imgD.write(to: URL(string: jpgPath)!, options: .init(rawValue: 0)) //!.writeToFile(jpgPath, atomically: true)
                
            } catch {
                print("Instagram sharing error")
            }
            
            let rect =  CGRect.init(x: 0, y: 0, width: 612, height: 612) //CGRectMake(0,0,612,612)
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = kUTI
            
            // adding caption for the image
            //com.instagram.sharedSticker.backgroundVideo
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            
            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
        } else {
            
            // alert displayed when the instagram application is not available in the device
            UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
        }
    }
    
    
    ///VIDEOOOOOOOOO
    func shareVideoToInstagramV2(videoData:NSData?,imageData:NSData?,caption:String?)
    {
        // let videoURL : NSURL = videoURL as NSURL
        
        //  let library = ALAssetsLibrary()
        // library.writeVideoAtPath(toSavedPhotosAlbum: videoURL as URL) { (newURL, error) in
        
        //   let caption = "write your caption here..."
        // let instagramString = "instagram://library?AssetPath=\((newURL!.absoluteString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics))!)"
        
        //let shareString = "https://itunes.apple.com/in/app/\(instagramString)"
        //let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        //let url = URL(string: escapedShareString)
        //print(url)
        
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                // guard let image = sharingImageView else { return }
                guard let _imageData = imageData else { return }
                guard let _videoData = videoData else { return }
                
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.backgroundVideo":_videoData, "com.instagram.sharedSticker.InstagramCaption":caption!,
                    "com.instagram.sharedSticker.stickerImage": _imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            } else {
                
                UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
                // print("User doesn't have instagram on their device.")
            }
        }
    }
}




//MARK: -Instagram SHARING End

//MARK: -Twitter SHARING

//func uploadImageOnTwitter(withText text: String, image: UIImage) {
//    guard let userId = store.session()?.userID else { return }
//    let client = TWTRAPIClient.init(userID: userId)
//    client.sendTweet(withText: text, image: image) {
//        (tweet, error) in
//
//        if error {
//            // Handle error
//            print(error?.localizedDescription)
//
//        } else {
//            // Handle Success
//            print(tweet)
//        }
//    }
//}

//MARK: -Twitter SHARING End

