//
//  PostHistoryModel.swift
//  SpotPraise
//
//  Created by admin on 27/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation


struct PostHistoryRootClass : Codable {
    
    let data : [PostHistoryData]?
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
        data = try values.decodeIfPresent([PostHistoryData].self, forKey: .data)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        response = try values.decodeIfPresent(String.self, forKey: .response)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
    
}

struct PostHistoryData : Codable {
    
    let companyTitle : String?
    let created : String?
    let descriptionField : String?
    let email : String?
    let id : String?
    let logoImage : String?
    let modified : String?
    let postImage : String?
    let thumbnail : String?
    let userId : String?
    let video : String?
    let webLink : String?
    
    
    enum CodingKeys: String, CodingKey {
        case companyTitle = "company_title"
        case created = "created"
        case descriptionField = "description"
        case email = "email"
        case id = "id"
        case logoImage = "logo_image"
        case modified = "modified"
        case postImage = "post_image"
        case thumbnail = "thumbnail"
        case userId = "user_id"
        case video = "video"
        case webLink = "web_link"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        companyTitle = try values.decodeIfPresent(String.self, forKey: .companyTitle)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        logoImage = try values.decodeIfPresent(String.self, forKey: .logoImage)
        modified = try values.decodeIfPresent(String.self, forKey: .modified)
        postImage = try values.decodeIfPresent(String.self, forKey: .postImage)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        video = try values.decodeIfPresent(String.self, forKey: .video)
        webLink = try values.decodeIfPresent(String.self, forKey: .webLink)
    }
    
    
}
