import Foundation
import UIKit

//MARK: -UITExtFiels
private var __maxLengths = [UITextField: Int]()

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t!.prefix(maxLength).description//.prefix(maxLength)
    }

}



//MARK:- NSObject
extension UIView{
    @IBInspectable
    var serCorR: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var circleIt: Bool{
        get{
            return self.circleIt
        }
        set (hasDone) {
            if hasDone{
                self.layer.cornerRadius = self.frame.height/2
            }
        }
    }
}

//MARK:- NSObject
extension NSObject {
    
    ///MARK:- To Get StoryBoard from Identifire
    func getVC(withId storyBoardId : String? , storyBoardName : String?) -> UIViewController {
        
        let vc = UIStoryboard.init(name: /storyBoardName, bundle: Bundle.main).instantiateViewController(withIdentifier: /storyBoardId)
        return vc
    }
    
}

//MARK:- UIApplication

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
//MARK:- STRING EXTENSTION


extension String {
    
    mutating func removeCharsFromEnd(removeCount:Int)
    {
        let subText = String(self.prefix(removeCount))
        self = subText
        
    }
    //        func removeCharsFromEnd(count_:Int) -> String {
    //            let stringLength = self.count
    //
    //            let substringIndex = (stringLength < count_) ? 0 : stringLength - count_
    //
    //            return self.substringToIndex(advance)
    //        }
    
    func toNumber()->Double{
        var rInt = 0.0
        if let  conInt = Int(self ) {
            rInt = Double(conInt)
        }
        else if let conDouble = Double(self){
            rInt = conDouble
        }
        return rInt
    }
    
    public func range(ofText text: String) -> NSRange {
        let fullText = self
        let range = (fullText as NSString).range(of: text)
        return range
    }
    //func convertDateFormater( date InString: String?, fromFormat:DateFormat, toFormat:DateFormat) -> String
    //    {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = fromFormat.get()//"yyyy-MM-dd HH:mm:ss"
    //        guard   let date = dateFormatter.date(from: InString!) else {
    //            Logs.printLog("Unable to convert date format")
    //            return "" }
    //        dateFormatter.dateFormat = toFormat.get()//"HH:mm"
    //        // console(dateFormatter.string(from: date))
    //        return  dateFormatter.string(from: date)
    //    }
    
    func splitString(from location:Int, to length:Int )->String{
        var str = NSString()
        str = self as NSString
        str =  str.substring(with: NSRange(location: location, length: length)) as NSString
        return str as String
    }
    
    /// Localised String
    var localized: String {
        return NSLocalizedString(self, comment:"")
    }
    
    /// Trim String
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width + 8
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        
        let font = font
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height + 16
    }
    
    
    ///To 12 Hour Format
    var to12HoursFormat : String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "H:mm"
        if let formattedTime = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: formattedTime)
        }else {
            return nil
        }
    }
    //
    ///To 24 Hour Format
    var to24HoursFormat : String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "hh:mm a"
        if let formattedTime = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: formattedTime)
        }else {
            return nil
        }
    }
    
    public func isNumber() -> Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    //string to date
    func stringToDateWithFormat(format:String)->Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Your date format
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date1 = dateFormatter.date(from: String(self)) //according to date format your date string
        return date1 ?? Date()
    }
    
    
    ///Convert into Base 64 Value
    func toBase64() -> String? {
        
        guard let data = self.data(using: String.Encoding.utf8) else {  return nil }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    ///Convert JSON String to Dictionary
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
