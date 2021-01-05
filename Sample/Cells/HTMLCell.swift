//
//  HTMLCell.swift
//  Sample
//
//  Created by Virginia Cook on 11/29/20.
//

import Foundation
import UIKit
import WebKit

class HTMLCell: UICollectionViewCell {
    
    private let htmlLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Constructors
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        self.contentView.addSubview(htmlLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(with html: NSAttributedString) {
        htmlLabel.attributedText = html
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelSize: CGSize = htmlLabel.sizeThatFits(CGSize(width: self.contentView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        htmlLabel.frame = CGRect(x: 0.0, y: 0.0, width: labelSize.width, height: labelSize.height)
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: labelSize.height)
    }
}
