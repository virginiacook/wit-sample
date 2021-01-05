//
//  AuthorsViewController.swift
//  Sample
//
//  Created by Virginia Cook on 11/20/20.
//

import Foundation
import UIKit

class AuthorsViewController: UIViewController {
    
    private var authors: [Author] = []
    
    private let spacing: CGFloat = 20.0
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name, First Name"
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 4.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        button.setTitle("Search", for: .normal)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemTeal
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        return collectionView
    }()
    
    // MARK: - Cells
    
    private var calc = CalculatorCells()
    
    private struct CalculatorCells {
        let authorCell = AuthorCell()
    }
    
    private struct ReuseIdentifiers {
        static let authors = "authorsCellIdentifier"
    }
    
    // MARK: - Constructors
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Search for Authors"
        self.view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        textField.delegate = self
        
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cells
        collectionView.register(AuthorCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.authors)
        
        // add in any subviews (might want to move this)
        self.view.addSubview(textField)
        self.view.addSubview(searchButton)
        self.view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let textFieldHeight: CGFloat = 80.0

        let startingY: CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 0.0
        
        let searchButtonSize = searchButton.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat.greatestFiniteMagnitude))
        searchButton.frame = CGRect(x: self.view.frame.width - searchButtonSize.width - spacing, y: startingY + (textFieldHeight / 2.0) - (searchButtonSize.height / 2.0), width: searchButtonSize.width, height: searchButtonSize.height)
        
        textField.frame = CGRect(x: spacing, y: startingY, width: searchButton.frame.minX - (spacing * 2.0), height: textFieldHeight)

        
        collectionView.frame = CGRect(x: 0.0, y: textField.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - textField.frame.maxY)
    }
    
    // MARK: - Events
    
    @objc private func didTapSearch() {
        processSearchField()
    }
    
    private func processSearchField() {
        textField.resignFirstResponder()

        guard let searchString = textField.text, !searchString.isEmpty else { return }
        
        let components = searchString.components(separatedBy: ", ")
        if components.count > 1 {
            requestAuthors(with: components[0], firstName: components[1])
        } else if components.count > 0 {
            requestAuthors(with: components[0], firstName: nil)
        }
        
    }
    
    // MARK: - Services
    
    private func requestAuthors(with lastName: String, firstName: String?) {
        AuthorsService.getAuthors(lastName: lastName, firstName: firstName) { [weak self] authors in
            self?.authors = authors
            self?.collectionView.reloadData()
        }
    }
    
    
}

// MARK: - UICollectionViewDelegate & Datasource Methods

extension AuthorsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return authors.count
    }
    
    // cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let author = authors[indexPath.row]
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.authors, for: indexPath) as! AuthorCell
        cell.configure(with: author)
        return cell
    }
    
    // cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let author = authors[indexPath.row]

        let authorVC = AuthorViewController(with: author)
        self.navigationController?.pushViewController(authorVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let author = authors[indexPath.row]
        calc.authorCell.frame = CGRect(x: 0.0, y: 0.0, width: self.collectionView.contentSize.width, height: 0.0)
        calc.authorCell.configure(with: author)
        return calc.authorCell.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

// MARK: - TextField Delegate

extension AuthorsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processSearchField()
        return true
    }
}
