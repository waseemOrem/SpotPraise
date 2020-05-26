//
//    RootClass.swift
//
//    Create by admin on 26/5/2020
//    Copyright © 2020. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct RegistrationRootClass : Codable {
    
    let data : RegistrationData?
    let msg : String?
    let response : String?
    let status : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case msg = "msg"
        case response = "response"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       // data = try RegistrationData(from: decoder)
           data = try values.decodeIfPresent(RegistrationData.self, forKey: .data)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        response = try values.decodeIfPresent(String.self, forKey: .response)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
    
}

struct RegistrationData : Codable {
    
    let activationKey : String?
    let address : String?
    let countryCode : String?
    let created : String?
    let deviceToken : String?
    let deviceType : String?
    let email : String?
    let firstname : String?
    let forgotKey : String?
    let id : String?
    let image : String?
    let lastname : String?
    let lat : String?
    let lng : String?
    let modified : String?
    let name : String?
    let notification : String?
    let pass : String?
    let password : String?
    let phone : String?
    let recievePush : String?
    let socialId : String?
    let socialType : String?
    let status : String?
    let token : String?
    let userType : String?
    let username : String?
    
    
    enum CodingKeys: String, CodingKey {
        case activationKey = "activationKey"
        case address = "address"
        case countryCode = "country_code"
        case created = "created"
        case deviceToken = "deviceToken"
        case deviceType = "deviceType"
        case email = "email"
        case firstname = "firstname"
        case forgotKey = "forgot_key"
        case id = "id"
        case image = "image"
        case lastname = "lastname"
        case lat = "lat"
        case lng = "lng"
        case modified = "modified"
        case name = "name"
        case notification = "notification"
        case pass = "pass"
        case password = "password"
        case phone = "phone"
        case recievePush = "recieve_push"
        case socialId = "social_id"
        case socialType = "social_type"
        case status = "status"
        case token = "token"
        case userType = "userType"
        case username = "username"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        activationKey = try values.decodeIfPresent(String.self, forKey: .activationKey)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        deviceToken = try values.decodeIfPresent(String.self, forKey: .deviceToken)
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        firstname = try values.decodeIfPresent(String.self, forKey: .firstname)
        forgotKey = try values.decodeIfPresent(String.self, forKey: .forgotKey)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lng = try values.decodeIfPresent(String.self, forKey: .lng)
        modified = try values.decodeIfPresent(String.self, forKey: .modified)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        notification = try values.decodeIfPresent(String.self, forKey: .notification)
        pass = try values.decodeIfPresent(String.self, forKey: .pass)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        recievePush = try values.decodeIfPresent(String.self, forKey: .recievePush)
        socialId = try values.decodeIfPresent(String.self, forKey: .socialId)
        socialType = try values.decodeIfPresent(String.self, forKey: .socialType)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }
    
    
}
