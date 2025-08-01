//
//  User.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/22.
//

import Foundation
import SwiftData

// @Observableでもいい
@Model
final class User {
    var name: String
    var accountName: String
    var iconName: String
    var numberOfStars: Int
    var message: String

    init(name: String, accountName: String, iconName: String, numberOfStars: Int, message: String) {
        self.name = name
        self.accountName = accountName
        self.iconName = iconName
        self.numberOfStars = numberOfStars
        self.message = message
    }

    func minusNumberOfStars() {
        self.numberOfStars = max(0, self.numberOfStars - 1)
    }

    func plusNumberOfStars() {
        self.numberOfStars = min(5, self.numberOfStars + 1)
    }
}


extension User {
    static var dummy1: User {
        .init(
            name: "山田太郎",
            accountName: "@yamada",
            iconName: "person_01",
            numberOfStars: 4,
            message:
"""
今日も１日がんばるぞい！
でも働きたくはないなああああ
何か楽しいことないのかあ！！
"""
        )
    }
}
