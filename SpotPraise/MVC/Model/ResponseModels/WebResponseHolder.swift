import Foundation

class ModelDataHolder:NSObject{
    static let shared = ModelDataHolder()
    var loggedData:RegistrationData?
//    var categoryHolder =  [CategoryData]()
//    var interestHolder = [InterestData]()
}
