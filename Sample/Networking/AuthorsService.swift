//
//  Services.swift
//  Sample
//
//  Created by Virginia Cook on 11/21/20.
//

import Foundation
import Alamofire



class AuthorsService {

    static let headers: HTTPHeaders = [
        "Accept" : "application/json",
        "content-type" : "application/json"
    ]
    
    static func getAuthors(lastName: String, firstName: String?, completion:@escaping ([Author]) -> Void) {
        
        let parameters: Parameters
        if let firstName = firstName {
            parameters = ["lastName" : lastName, "firstName" : firstName]
        } else {
            parameters = ["lastName" : lastName]
        }
        
        AF.request("https://reststop.randomhouse.com/resources/authors", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let authors = try decoder.decode(Authors.self, from: data)
                completion(authors.authors.filter({ $0.spotlight != nil }))
            } catch let error {
                print(error)
                completion([])
            }
            
        }
    }
    
    static func getBooksForAuthor(authorId: String, completion:@escaping ([Book]) -> Void) {
        let parameters: Parameters = ["authorid" : authorId]
        AF.request("https://reststop.randomhouse.com/resources/titles", method: .get, parameters: parameters, headers: headers).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let books = try decoder.decode(Books.self, from: data)
                completion(books.uniqueBooksWithDescriptions)
            } catch let error {
                print(error)
                completion([])
            }
        }
    }
}
