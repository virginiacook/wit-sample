//
//  String.swift
//  Sample
//
//  Created by Virginia Cook on 11/29/20.
//

import Foundation

extension String {
    
    var parsedHTML: NSAttributedString? {
        if let parsedString = try? NSAttributedString(
            data: self.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil) {
            
            return parsedString
            
        } else {
            
            return nil
            
        }
    }
    
}
