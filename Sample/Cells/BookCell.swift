//
//  BookCell.swift
//  Sample
//
//  Created by Virginia Cook on 11/29/20.
//

import Foundation
import UIKit

class BookCell: UICollectionViewCell {
    
    weak var delegate: BookCellDelegate?

    private var book: Book?
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.italicSystemFont(ofSize: 18.0)
        return nameLabel
    }()
    
    private let pagesLabel: UILabel = UILabel()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 4.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        return button
    }()
    
    // MARK: - Constructors
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(pagesLabel)
        self.contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(with book: Book) {
        self.book = book
        
        pagesLabel.isHidden = true
        
        nameLabel.text = book.title
        
        if let pages = book.nonEmptyPages {
            pagesLabel.text = pages
            pagesLabel.isHidden = false
        }
        
        if let price = book.formattedPrice {
            button.setTitle("Buy Now - \(price)", for: .normal)
        } else {
            button.setTitle("Buy Now", for: .normal)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // MARK: - Events
    
    @objc
    private func didTapBuy() {
        guard let url = book?.webURL else { return }
        delegate?.bookCellDidTapBuy(cell: self, url: url)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing: CGFloat = 10.0
        
        var yPos: CGFloat = 0.0
        
        let maxItemSize = CGSize(width: self.contentView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        
        let nameLabelSize: CGSize = nameLabel.sizeThatFits(maxItemSize)
        nameLabel.frame = CGRect(x: 0.0, y: yPos, width: nameLabelSize.width, height: nameLabelSize.height)
        
        yPos += nameLabelSize.height + spacing
        
        if !pagesLabel.isHidden {
            let pagesLabelSize: CGSize = pagesLabel.sizeThatFits(maxItemSize)
            pagesLabel.frame = CGRect(x: 0.0, y: yPos, width: pagesLabelSize.width, height: pagesLabelSize.height)
            yPos += pagesLabelSize.height + spacing
        }
        
        let buttonSize: CGSize = button.sizeThatFits(maxItemSize)
        button.frame = CGRect(x: (maxItemSize.width / 2.0) - (buttonSize.width / 2.0), y: yPos, width: buttonSize.width, height: buttonSize.height)
        yPos += buttonSize.height
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: yPos)
    }
    
}

// MARK: - BookCellDelegate

protocol BookCellDelegate: class {
    
    func bookCellDidTapBuy(cell: BookCell, url: URL)
    
}
