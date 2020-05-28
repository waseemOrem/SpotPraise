//
//  PublicEnums.swift
//  Spot Praise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//


//MARK:- STORYBOARD IDS
enum Storyboards : String {
    
    case Login = "Main"
    // case Home = "Home"
    case Home = "Home"
    case Business = "BusinessStory"
    
}
enum MESSAGES:String{
    case RESPONSE_ERROR = "We are sorry to process your request this time please try again later."
    case AUTH_ERROR = "Error to save authetication!! App will response abnormal"
    case NETWORK_ERROR = "Seem network connection is not available!"
    case ADDRESS_ERROR = "Unble to find address please try again."
    case SUCCESS = "Success"
    case ENABLE_LOCATION = "Please enable location to contnue."
    case UNDER_PROCESS = "Coming soon!"
}
enum VC : String {
    case MainNavigationViewController = "MainNavigationViewController"
    case LoginVC = "LoginVC"
    case SignUpVC = "SignUpVC"
    case ChangePssVC = "ChangePssVC"
    case ForgotVC =  "ForgotVC"
    case OTPVerificationVC = "OTPVerificationVC"
    
    case HomeVC = "HomeVC"
    case UploadVideoPopUpVC = "UploadVideoPopUpVC"
    case DescriptionVC = "DescriptionVC"
    case ProfileVC = "ProfileVC"
    case PostVideoPOPVC  = "PostVideoPOPVC"
    case SubscriptionVC = "SubscriptionVC"
    case PostHistoryVC  = "PostHistoryVC"
    case PostDetailVC = "PostDetailVC"
    case SubscriptionPlanPopVC = "SubscriptionPlanPopVC"
    case PersonalInfoVC = "PersonalInfoVC"
    
}

enum CustomFontPoppins:String{
    case  ExtraBold  = "Poppins-ExtraBold"
    case Light  = "Poppins-Light"
    case  Bold = "Poppins-Bold"
    case Medium = "Poppins-Medium"
    case SemiBold = "Poppins-SemiBold"
    case Regular = "Poppins-Regular"
    case  Thin = "Poppins-Thin"
}
enum TableCells:String{
    case ProfileTableCell = "ProfileTableCell"
    case PostHistoryTableCell = "PostHistoryTableCell"
    
}

enum SocialApps{
    case FaceBook, Twitter,Youtube,Linked,Instagram
}
enum UploadChoices{
    case UploadImage , UploadVideo
}
