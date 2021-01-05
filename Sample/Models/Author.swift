//
//  Author.swift
//  Sample
//
//  Created by Virginia Cook on 11/20/20.
//

import Foundation

struct Authors: Codable {
    let authors: [Author]
    
    enum CodingKeys: String, CodingKey {
        case authors = "author"
    }
}

struct Author: Codable {
    
    let id: String
    let firstName: String?
    let lastName: String
    let spotlight: String?
    
    var html: NSAttributedString? {
        return spotlight?.parsedHTML
    }
    
    var fullName: String {
        if let firstName = firstName {
            return firstName + " " + lastName
        } else {
            return lastName
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "authorid"
        case firstName = "authorfirst"
        case lastName = "authorlast"
        case spotlight = "spotlight"
    }
}



