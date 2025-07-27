//
//  UIStackView+.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/27.
//
import UIKit

extension UIStackView {
    func arrangedSubviews<T: UIView>(ofType type: T.Type) -> [T] {
        arrangedSubviews.compactMap { $0 as? T }
    }
}
