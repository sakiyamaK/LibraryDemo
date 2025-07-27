//
//  ViewController.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/22.
//

import UIKit
import DeclarativeUIKit
import ObservableUIKit
import SwiftUI
import SwiftUIKit

class ViewController: UIViewController {

    private let userCardViewNib = UINib(nibName: "UserCardViewXib", bundle: nil).instantiate(withOwner: nil).first! as! UserCardViewXib

    private let user1 = User.dummy1
    private let user2 = User.dummy1
    private let user3 = User.dummy1
    private let user4 = User.dummy1
    private let user5 = User.dummy1

    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = UIStackView.vertical(spacing: 16)

        // declarativeでself.viewの上にaddSubViewされ四隅を揃えるようになる
        self.declarative {
            UIScrollView.vertical {

                // インスタンス生成後に宣言的に複数のViewをaddArrangedSubviewで追加できる
                stackView.addArrangedSubviews {
                    // Xibから読み込み
                    self.userCardViewNib

                    // 普通にコードで制約を貼ってレイアウト
                    UserCardViewNormalCode(
                        user: self.user1,
                        delegate: .init(
                            tapAction: {[weak self] userCardView in
                                guard let self else { return }
                                self.user1.minusNumberOfStars()
                                userCardView.configure(user: self.user1)
                            })
                    )

                    // DeclarativeUIKitでレイアウト
                    UserCardDeclarativeCode(
                        user: self.user2,
                        delegate: .init(
                            tapAction: {[weak self] userCardView in
                                guard let self else { return }
                                self.user2.minusNumberOfStars()
                                userCardView.configure(user: self.user2)
                            })
                    )

                    // DeclarativeUIKitでレイアウト + ObservableUIKitでデータ更新
                    UserCardViewObservableCode(
                        user: self.user3,
                        delegate: .init(
                            tapAction: {[weak self] in
                                guard let self else { return }
                                self.user3.minusNumberOfStars()
                            })
                    )

                    // 内部は主にSwiftUIでレイアウトされたUIView
                    SwiftUIinUIKitView(
                        user: self.user4,
                        delegate: .init(
                            tapAction: {[weak self] in
                                guard let self else { return }
                                self.user4.minusNumberOfStars()
                            })
                    )

                    // ここから中はSwiftUI
                    SwiftUIView {
                        // SwiftUIだけで作られたView
                        OnlySwiftUIView(
                            user: self.user5,
                            delegate: .init(
                                tapAction: {[weak self] in
                                    guard let self else { return }
                                    self.user5.minusNumberOfStars()
                                })
                        )
                    }
                }
                .margins(.init(horizontal: 8))
            }
            .contentInset(.init(bottom: 160))
        }.floatingActionView {
            /*
             デフォルトで右下に寄せる設定になっているが、9箇所に貼れるし微調整もできる
             .floatingActionView(position: .trailingBottom(CGPoint(x: 16, y: 16)))
             */
            UIStackView.vertical {

                UIButton(
                    configuration: .bordered().image(UIImage(systemName: "minus")!).cornerStyle(.capsule).contentInsets(.init(all: 16)),
                    primaryAction: .init(
                        handler: {[weak self] _ in
                            guard let self else { return }
                            // ObservableUIKitでデータ更新
                            self.user3.minusNumberOfStars()
                            self.user4.minusNumberOfStars()
                            self.user5.minusNumberOfStars()
                        }
                    )
                )

                UIButton(
                    configuration: .bordered().image(UIImage(systemName: "plus")!).cornerStyle(.capsule).contentInsets(.init(all: 16)),
                    primaryAction: .init(
                        handler: {[weak self] _ in
                            guard let self else { return }
                            // ObservableUIKitでデータ更新
                            self.user3.plusNumberOfStars()
                            self.user4.plusNumberOfStars()
                            self.user5.plusNumberOfStars()
                        }
                    )
                )
            }
            .spacing(16)
        }

        /*
         標準のUIKitのレイアウトの作り方とも組み合わせることができる
         つまり既存プロジェクトのレイアウトの資産で残したい部分は残せる
         */
        let label = UILabel("お　し　ま　い")
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        stackView.addArrangedSubview(label)
    }
}


#Preview {
    ViewController()
}
