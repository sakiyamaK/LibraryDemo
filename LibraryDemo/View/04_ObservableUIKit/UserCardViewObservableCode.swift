//
//  UserCardViewObservable.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/22.
//

import UIKit
import DeclarativeUIKit
import ObservableUIKit

final class UserCardViewObservableCode: UIView {

    struct Delegate {
        var tapAction: () -> Void
    }

    var user: User?
    private var delegate: Delegate?

    convenience init(user: User?, delegate: Delegate? = nil) {
        self.init(frame: .zero)

        self.user = user
        self.delegate = delegate

        self.declarative {
            UIButton(configuration: .plain(), primaryAction: .init(handler: {[weak self] _ in
                self?.delegate?.tapAction()
            })).zStack(priorities: .init(bottom: .defaultHigh)) {
                UIStackView.vertical {
                    UIStackView.horizontal {
                        UIImageView()
                            .tracking({[weak self] in
                                // 監視したいパラメータ
                                self!.user?.iconName
                            }, onChange: { imageView, iconName in
                                // 監視したいパラメータが変更されたら実行される
                                imageView.image(UIImage(named: iconName))
                            })
                            .contentMode(.scaleAspectFit)
                            .contentPriorities(.init(all: .required))
                            .size(width: 100, height: 100)

                        UIStackView.vertical {
                            UILabel()
                                .tracking({[weak self] in
                                    self!.user?.name
                                }, onChange: { label, name in
                                    label.text(name)
                                })
                                .font(.systemFont(ofSize: 17, weight: .medium))
                                .textColor(.label)
                                .contentPriorities(.init(vertical: .required))
                            UILabel()
                                .tracking({[weak self] in
                                    self!.user?.accountName
                                }, onChange: { label, accountName in
                                    label.text(accountName)
                                })
                                .font(.systemFont(ofSize: 17, weight: .medium))
                                .textColor(.label)
                                .contentPriorities(.init(vertical: .required))
                        }
                        .distribution(.fillEqually)
                    }
                    .spacing(10)

                    UIStackView.horizontal {
                        (0..<5).compactMap { _ in
                            UIImageView()
                                .contentMode(.scaleAspectFit)
                                .aspectRatio(1.0)
                                .contentPriorities(.init(all: .required))
                        }
                    }
                    .tracking({[weak self] in
                        self!.user?.numberOfStars
                    }, onChange: {[weak self] stackView, numberOfStars in
                        for (i, imageView) in stackView.arrangedSubviews.compactMap({ $0 as? UIImageView }).enumerated() {
                            imageView.image(UIImage(named: i < self!.user!.numberOfStars ? "star_fill" : "star"))
                        }
                    })
                    .spacing(8)

                    UITextView()
                        .tracking({[weak self] in
                            self!.user?.message
                        }, onChange: { textView, message in
                            textView.text(message)
                        })
                        .apply({ textView in
                            /**
                             このように手続的に書くこともできる

                             なので

                             もし非対応のパラメータがあっても、
                             今後のバージョンアップで新しいコンポーネントが増えても、
                             UIKit.UIViewを継承している限り宣言的にレイアウトが組める
                             */
                            textView.font = .systemFont(ofSize: 27, weight: .regular)
                            textView.isScrollEnabled = true
                            textView.isEditable = false
                        })
//                        .font(.systemFont(ofSize: 27, weight: .regular))
//                        .isScrollEnabled(true)
//                        .isEditable(false)
                        .contentPriorities(.init(vertical: .required))
                        .height(100)

                }
                .margins(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                .cornerRadius(16)
                .border(color: .systemGray, width: 1.0)
                .backgroundColor(.systemBackground)
                .isUserInteractionEnabled(false)
            }
        }
    }
}

#Preview(
    traits: .fixedLayout(width: 400, height: 300),
    body: {
        {
            let user = User.dummy1
            return UserCardViewObservableCode(
                user: user,
                delegate: .init(
                    // タップしたらuser情報を更新
                    // viewはobservableによって勝手に同期される
                    tapAction: {
                        user.minusNumberOfStars()
                })
            )
    }()
})
