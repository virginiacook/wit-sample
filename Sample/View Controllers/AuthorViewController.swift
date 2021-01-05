//
//  AuthorViewController.swift
//  Sample
//
//  Created by Virginia Cook on 11/20/20.
//

import Foundation
import UIKit
import SafariServices

class AuthorViewController: UICollectionViewController {
    
    private let author: Author
    
    private var books: [Book] = []
    
    // MARK: - Cells
    
    private var calc = CalculatorCells()
    
    private struct CalculatorCells {
        let authorCell = AuthorCell()
        let bookCell = BookCell()
        let htmlCell = HTMLCell()
        let headerView = HeaderView()
    }
    
    private struct ReuseIdentifiers {
        static let author = "authorCellIdentifier"
        static let book = "bookCellIdentifier"
        static let html = "htmlCellIdentifier"
        static let headerView = "headerViewIdentifier"
    }
    
    // MARK: - Sections
    
    private var sections: [Section] = []
    
    private enum Section {
        case details(author: Author)
        case books(books: [Book])
        
        var rows: [Row] {
            switch self {
            case .details(author: let author):
                var detailsRows: [Row] = [.author(author: author)]
                if let authorHTML = author.html {
                    detailsRows.append(.html(html: authorHTML))
                }
                return detailsRows
            case .books(books: let books):
                var booksRows: [Row] = []
                
                books.forEach { book in
                    booksRows.append(.book(book: book))
                    if let bookHTML = book.html {
                        booksRows.append(.html(html: bookHTML))
                    }
                }
                return booksRows
            }
        }
        
        var headerTitle: String {
            switch self {
            case .details(_):
                return "Details"
            case .books(_):
                return "Books"
            }
        }
    }
    
    private enum Row {
        case author(author: Author)
        case book(book: Book)
        case html(html: NSAttributedString)
    }
    
    // MARK: - Constructors
    
    init(with author: Author) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        
        self.author = author
        
        super.init(collectionViewLayout: layout)
        self.title = author.fullName
        
        self.collectionView.backgroundColor = .white
        self.collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        requestTitles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // register cells + views
        self.collectionView.register(AuthorCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.author)
        self.collectionView.register(BookCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.book)
        self.collectionView.register(HTMLCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.html)
        self.collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifiers.headerView)
        
    }
    
    // MARK: - Construct Sections
    
    private func createSections() {
        self.sections = [.details(author: author), .books(books: books)]
    }
    
    // MARK: - Services
    
    private func requestTitles() {
        AuthorsService.getBooksForAuthor(authorId: author.id) { [weak self] books in
            self?.books = books
            self?.createSections()
            self?.collectionView.reloadData()
        }
    }
    
    
}

// MARK: - UICollectionViewDelegate & Datasource Methods

extension AuthorViewController {
    // number of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    // number of items in section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    // cell for item
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = sections[indexPath.section].rows[indexPath.item]
        switch row {
        
        case .author(author: let author):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.author, for: indexPath) as! AuthorCell
            cell.configure(with: author)
            return cell
        case .book(book: let book):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.book, for: indexPath) as! BookCell
            cell.configure(with: book)
            cell.delegate = self
            return cell
        case .html(html: let html):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.html, for: indexPath) as! HTMLCell
            cell.configure(with: html)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifiers.headerView, for: indexPath) as! HeaderView
        headerView.configure(with: section.headerTitle)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = sections[section]
        calc.headerView.frame = CGRect(x: 0.0, y: 0.0, width: self.collectionView.contentSize.width, height: 0.0)
        calc.headerView.configure(with: section.headerTitle)
        return calc.headerView.frame.size
    }
}

extension AuthorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = sections[indexPath.section].rows[indexPath.item]
        switch row {
        case .author(author: let author):
            calc.authorCell.frame = CGRect(x: 0.0, y: 0.0, width: self.collectionView.contentSize.width, height: 0.0)
            calc.authorCell.configure(with: author)
            return calc.authorCell.frame.size
        case .book(book: let book):
            calc.bookCell.frame = CGRect(x: 0.0, y: 0.0, width: self.collectionView.contentSize.width, height: 0.0)
            calc.bookCell.configure(with: book)
            return calc.bookCell.frame.size
        case .html(html: let html):
            calc.htmlCell.frame = CGRect(x: 0.0, y: 0.0, width: self.collectionView.contentSize.width, height: 0.0)
            calc.htmlCell.configure(with: html)
            return calc.htmlCell.frame.size
        }
    }
}

extension AuthorViewController: BookCellDelegate {
    func bookCellDidTapBuy(cell: BookCell, url: URL) {
        let safariVC = SFSafariViewController(url: url)
        
        self.present(safariVC, animated: true)
    }
    
    
}
