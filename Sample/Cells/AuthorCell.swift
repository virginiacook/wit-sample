//
//  AuthorCell.swift
//  Sample
//
//  Created by Virginia Cook on 11/25/20.
//

import Foundation
import UIKit

class AuthorCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    private let margin: CGFloat = 10.0
    
    // MARK: - Constructors
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.contentView.addSubview(nameLabel)
        self.contentView.backgroundColor = .systemPink
        self.contentView.layer.cornerRadius = 4.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(with author: Author) {
        nameLabel.text = author.fullName
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelSize: CGSize = nameLabel.sizeThatFits(CGSize(width: self.contentView.frame.width - (margin * 2.0), height: CGFloat.greatestFiniteMagnitude))
        nameLabel.frame = CGRect(x: margin, y: margin, width: labelSize.width, height: labelSize.height)
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: labelSize.height + (margin * 2.0))
    }
}
