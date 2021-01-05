//
//  Book.swift
//  Sample
//
//  Created by Virginia Cook on 11/20/20.
//

import Foundation

struct Books: Codable {
    let books: [Book]?
    
    var uniqueBooksWithDescriptions: [Book] {
        guard let books = books else { return [] }
        let booksWithDescriptions = books.filter({ $0.snippet != nil })
        return Array(Set(booksWithDescriptions))
    }
    
    enum CodingKeys: String, CodingKey {
        case books = "title"
    }
}

struct Book: Codable, Hashable, Equatable {
    

    let title: String
    let pages: String
    let workId: String
    let price: String?
    let snippet: String?
    
    var html: NSAttributedString? {
        return snippet?.parsedHTML
    }
    
    var formattedPrice: String? {
        guard let price = price else { return nil }
        return "$\(price)"
    }
    
    var nonEmptyPages: String? {
        return pages != "0" ? "\(pages) pages" : nil
    }
    
    var webURL: URL? {
        return URL(string: "https://www.penguinrandomhouse.com/books/\(workId)")
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "titleweb"
        case pages = "pages"
        case price = "priceusa"
        case snippet = "acmartflap"
        case workId = "workid"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(workId)
    }
    
    public static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
