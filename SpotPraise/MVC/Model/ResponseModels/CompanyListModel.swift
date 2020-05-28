//
//    RootClass.swift
//
//    Create by admin on 28/5/2020
//    Copyright © 2020. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CompanyListRootClass : Codable {
    
    let data : [CompanyListData]?
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
        data = try values.decodeIfPresent([CompanyListData].self, forKey: .data)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        response = try values.decodeIfPresent(String.self, forKey: .response)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
    
}



struct CompanyListData : Codable {
    
    let address : String?
    let email : String?
    let id : String?
    let name : String?
    
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case email = "email"
        case id = "id"
        case name = "name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
    
}
