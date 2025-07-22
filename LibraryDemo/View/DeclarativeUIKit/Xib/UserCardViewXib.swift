//
//  UserCardView.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/22.
//
import UIKit

final class UserCardViewXib: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
