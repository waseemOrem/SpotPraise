import UIKit
import Foundation

struct ImageMerger {
    
//    private var postLogo:UIImage?
//    private var postImage:UIImage?
//    private var onView:UIView?
    
    
//    init(postLogo:UIImage?, postImage:UIImage?, onView:UIView?) {
//        self.postLogo = postLogo
//        self.postImage = postImage
//        self.onView  = onView
//    }
  private  static var imaginaryViewForMergeImageHolder:UIView = {
        let ing = UIView()
        ing.translatesAutoresizingMaskIntoConstraints = false
        return ing
    }()
    
    private  static var postBackgroundImageView:UIImageView = {
        let ing = UIImageView()
       ing.translatesAutoresizingMaskIntoConstraints = false
        ing.contentMode = .scaleAspectFill
        return ing
    }()
    
    
    private  static var postLogoImageView:UIImageView = {
        let ing = UIImageView()
        ing.translatesAutoresizingMaskIntoConstraints = false
        ing.contentMode = .scaleAspectFill
        return ing
    }()
    
    static  func removeViewFromSuper(){
    self.imaginaryViewForMergeImageHolder.removeFromSuperview()
        self.postBackgroundImageView.removeFromSuperview()
        self.postLogoImageView.removeFromSuperview()
    }
    static func createPostImage(postLogo:UIImage?, postBackgroundImage:UIImage?, onView:UIView?)-> UIImage?  {
        
        guard let onView = onView else {
            return  nil
        }
//        onView.addSubview(imaginaryViewForMergeImageHolder)
//        imaginaryViewForMergeImageHolder.topAnchor.constraint(equalTo: onView.topAnchor, constant: 10).isActive = true
//         imaginaryViewForMergeImageHolder.leadingAnchor.constraint(equalTo: onView.leadingAnchor, constant: 0).isActive = true
//         imaginaryViewForMergeImageHolder.trailingAnchor.constraint(equalTo: onView.trailingAnchor, constant: 0).isActive = true
//        //imaginaryViewForMergeImageHolder.heightAnchor.constraint(equalToConstant: onView.frame.height * 0.8).isActive =  true
//        imaginaryViewForMergeImageHolder.bottomAnchor.constraint(equalTo: onView.bottomAnchor, constant: 10).isActive = true
//
//        imaginaryViewForMergeImageHolder.backgroundColor = .red
//
//        onView.addSubview(postBackgroundImageView)
//        postBackgroundImageView.backgroundColor = .green
//        postBackgroundImageView.topAnchor.constraint(equalTo: imaginaryViewForMergeImageHolder.topAnchor, constant: 0).isActive = true
//         postBackgroundImageView.bottomAnchor.constraint(equalTo: imaginaryViewForMergeImageHolder.bottomAnchor, constant: 0).isActive = true
//         postBackgroundImageView.leadingAnchor.constraint(equalTo: imaginaryViewForMergeImageHolder.leadingAnchor, constant: 0).isActive = true
//         postBackgroundImageView.trailingAnchor.constraint(equalTo: imaginaryViewForMergeImageHolder.trailingAnchor, constant: 0).isActive = true
//
//
//        onView.addSubview(postLogoImageView)
//
//        postLogoImageView.backgroundColor = .black
//        postLogoImageView.topAnchor.constraint(equalTo: imaginaryViewForMergeImageHolder.topAnchor, constant: 20).isActive = true
//         postLogoImageView.trailingAnchor.constraint(equalTo: imaginaryViewForMergeImageHolder.trailingAnchor, constant:  -5).isActive = true
//        postLogoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        postLogoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        postLogoImageView.clipsToBounds = true
//
//        postLogoImageView.layer.cornerRadius = postLogoImageView.frame.width/2
//        postLogoImageView.image = postLogo
        
        
       postBackgroundImageView.image = self.mergedImageWith(bgView: onView,
                                                            frontImage: postLogo,
                                                            backgroundImage: postBackgroundImage)
        
        //imaginaryViewForMergeImageHolder.removeFromSuperview()
        print(postBackgroundImageView.image)
        return postBackgroundImageView.image
        
 
    }
    
    
   private static func mergedImageWith(bgView:UIView,frontImage:UIImage?, backgroundImage: UIImage?) -> UIImage{
    
    let size = bgView.frame.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        backgroundImage?.draw(in: bgView.frame)
    
    var fImg = frontImage
    //at:bgView.frame.origin, blendMode: .copy, alpha: 1)
//    let v = UIView()
//    v.backgroundColor = .white
//v.draw(CGRect(x: size.width * 0.8, y: 20, width:70, height:70 ))
   let imageView: UIImageView = UIImageView(image: frontImage)
//    v.addSubview(imageView)
//    fImg?.draw(in: CGRect(x: size.width * 0.8, y: 20, width:70, height:70 ))
    
    //imageView.image?.draw(in: CGRect(x: size.width * 0.8, y: 20, width:65, height:65 ))
//    imageView.draw(CGRect(x: size.width * 0.8, y: 20, width:65, height:65 ))
//    imageView.layer.cornerRadius = imageView.frame.width/2
//    imageView.contentMode = .scaleAspectFill
//    imageView.clipsToBounds = true
    imageView.image?.draw(in: CGRect(x: size.width * 0.8, y: 20, width:65, height:65 ))
   // imageView.image.d
    //fImg = maskRoundedImage(image: fImg!, radius: 40.0)
    
    //frontImage.circ
    //LeftImage?.draw(in: CGRect(x: 0, y: 0, width:size.width/2, height: size.height))
    //RightImage?.draw(in: CGRect(x: size.width/2, y: 0, width:size.width, height: size.height))

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    private static func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
   
}

