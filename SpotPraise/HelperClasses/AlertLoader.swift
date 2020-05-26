import UIKit

class Loader:NSObject  {
    
    let loaderView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: /UIScreen.main.bounds.width, height: /UIScreen.main.bounds.height))
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let dismissButton:UIButton = UIButton()
    let crossImage = UIImageView()
    var loaderLabel = UILabel()
    static let shared = Loader()
    
    
    override init() {
        super.init()
        loaderView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3889394264)
        activityIndicator.color = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        dismissButton.frame = CGRect.init(x: loaderView.frame.origin.x, y: loaderView.frame.origin.y + 30, width: 80, height: 25)
        dismissButton.backgroundColor = .clear
        // dismissButton.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        // dismissButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        dismissButton.addTarget(self, action: #selector(hideLoader), for: .touchUpInside)
    }
    
    func showLoader(hideCross:Bool = false) {
        
        guard let center = (UIApplication.shared.keyWindow?.center) else { return }
        loaderView.center =  center
        activityIndicator.center = center
        loaderView.addSubview(activityIndicator)
        loaderView.addSubview(dismissButton)
        
        if hideCross{
            loaderView.addSubview(crossImage)
            
            crossImage.translatesAutoresizingMaskIntoConstraints = false
            crossImage.centerXAnchor.constraint(equalTo: dismissButton.centerXAnchor, constant: 0).isActive = true
            crossImage.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor, constant: 0).isActive = true
            crossImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            crossImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
            crossImage.image = #imageLiteral(resourceName: "close")
        }
        
        
        UIApplication.shared.keyWindow?.addSubview(loaderView)
    }
    func showLoaderWithStatus(_withString:String){
        
        guard let center = (UIApplication.shared.keyWindow?.center) else { return }
        loaderView.center =  center
        loaderLabel = UILabel(frame: CGRect(x: center.x, y: center.y, width: 300, height: 30))
        
        activityIndicator.center = center
        loaderView.addSubview(activityIndicator)
        loaderLabel.text = _withString
        loaderLabel.textColor = .white
        loaderLabel.textAlignment = .center
        loaderView.addSubview(loaderLabel)
        
        loaderLabel.translatesAutoresizingMaskIntoConstraints = false
        loaderLabel.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor, constant: 0).isActive = true
        loaderLabel.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor, constant: activityIndicator.frame.height + 5 ).isActive = true
        
        UIApplication.shared.keyWindow?.addSubview(loaderView)
    }
    
    
    @objc func hideLoader() {
        
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        activityIndicator.removeFromSuperview()
        loaderView.removeFromSuperview()
        
        
        if self.loaderLabel.isDescendant(of: self.loaderView) {
            print("visible")
            self.loaderLabel.removeFromSuperview()
        }
        else{
            print("not visible")
        }
    }
}//

