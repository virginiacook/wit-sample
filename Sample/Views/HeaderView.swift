//
//  HeaderView.swift
//  Sample
//
//  Created by Virginia Cook on 11/30/20.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
    
    private let margin: CGFloat = 20.0
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    // MARK: - Constructors
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(with title: String) {
        label.text = title
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
        
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelSize = label.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(x: 0.0, y: margin, width: labelSize.width, height: labelSize.height)
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: labelSize.height + (margin * 2.0))
    }
}
