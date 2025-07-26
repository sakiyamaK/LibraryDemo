//
//  UserCardDeclarativeCode.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/22.
//

import UIKit
import DeclarativeUIKit

final class UserCardDeclarativeCode: UIView {

    struct Delegate {
        var tapAction: (UserCardDeclarativeCode) -> Void
    }

    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    private let accountLabel = UILabel()
    private let starStackView = UIStackView.horizontal()
    private let textView = UITextView()

    private var user: User?
    private var delegate: Delegate?

    convenience init(user: User?, delegate: Delegate? = nil) {
        self.init(frame: .zero)

        self.user = user
        self.delegate = delegate

        // declarativeの中で宣言的にレイアウトが組める
        self.declarative {
            UIButton(configuration: .plain(), primaryAction: .init(handler: {[weak self] _ in
                guard let self else { return }
                self.delegate?.tapAction(self)
            })).zStack {
                UIStackView.vertical {
                    UIStackView.horizontal {
                        self.iconView
                            .contentMode(.scaleAspectFit)
                            .contentPriorities(.init(all: .required))
                            .size(width: 100, height: 100)

                        UIStackView.vertical {
                            self.nameLabel
                                .font(.systemFont(ofSize: 17, weight: .medium))
                                .textColor(.label)
                                .contentPriorities(.init(vertical: .required))
                            self.accountLabel
                                .font(.systemFont(ofSize: 17, weight: .medium))
                                .textColor(.label)
                                .contentPriorities(.init(vertical: .required))
                        }
                        .distribution(.fillEqually)
                    }
                    .spacing(10)

                    self.starStackView.addArrangedSubviews {
                        (0..<5).compactMap { _ in
                            UIImageView()
                                .contentMode(.scaleAspectFit)
                                .aspectRatio(1.0)
                                .contentPriorities(.init(all: .required))
                        }
                    }
                    .distribution(.fillEqually)
                    .spacing(8)

                    self.textView
                        .font(.systemFont(ofSize: 27, weight: .regular))
                        .isScrollEnabled(true)
                        .isEditable(false)
                        .contentPriorities(.init(vertical: .required))
                        .height(100)
                }
                .margins(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                .cornerRadius(16)
                .border(color: .systemGray, width: 1.0)
                .backgroundColor(.systemBackground)
                .isUserInteractionEnabled(false)

                /*
                 UIStackView.margins, UIView.cornerRadius, UIView.borderなど
                 標準のUIKitにないけどよく使う設定は独自のメソッドを用意してる
                 */
            }
        }

        if let user {
            configure(user: user)
        }
    }

    func configure(user: User) {
        self.iconView.image(UIImage(named: user.iconName))
        self.nameLabel.text(user.name)
        self.accountLabel.text(user.accountName)
        let imageViews = starStackView.arrangedSubviews.compactMap({ $0 as? UIImageView })
        for (i, imageView) in imageViews.enumerated() {
            imageView.image(UIImage(named: i < user.numberOfStars ? "star_fill" : "star"))
        }
        self.textView.text(user.message)
    }
}

#Preview(
    traits: .fixedLayout(width: 400, height: 300),
    body: {
        {
            let user: User = User.dummy1
            
            let userCardView = UserCardDeclarativeCode(
                user: user,
                delegate: .init(
                    // タップしたらuser情報を更新してviewを更新
                    tapAction: { userCardView in
                    var newUser: User = user
                    newUser.numberOfStars = max(0, user.numberOfStars - 1)
                    userCardView.configure(user: newUser)
                })
            )

        return userCardView
    }()
})
