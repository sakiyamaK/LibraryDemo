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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.declarative {
            UIScrollView.vertical {
                UIStackView.vertical(spacing: 16) {

                    // Xibから読み込み
                    self.userCardViewNib

                    // 普通にコードで制約を貼ってレイアウト
                    UserCardViewNormalCode(user: self.user1, delegate: .init(tapAction: {[weak self] userCardView in
                        guard let self else { return }
                        let newUser = self.user1
                        newUser.numberOfStars = max(0, self.user1.numberOfStars - 1)
                        userCardView.config(user: newUser)
                    }))

                    // DeclarativeUIKitでレイアウト
                    UserCardDeclarativeCode(user: self.user2, delegate: .init(tapAction: {[weak self] userCardView in
                        guard let self else { return }
                        let newUser = self.user2
                        newUser.numberOfStars = max(0, self.user2.numberOfStars - 1)
                        userCardView.configure(user: newUser)
                    }))

                    // DeclarativeUIKitでレイアウト + ObservableUIKitでデータ更新
                    UserCardViewObservableCode(user: self.user3, delegate: .init(tapAction: {[weak self] in
                        guard let self else { return }
                        self.user3.numberOfStars = max(0, self.user3.numberOfStars - 1)
                    }))

                    // 内部は主にSwiftUIでレイアウト
                    SwiftUIinUIKitView(user: self.user4, delegate: .init(tapAction: {[weak self] in
                        guard let self else { return }
                        self.user4.numberOfStars = max(0, self.user4.numberOfStars - 1)
                    }))

                    // 当然ViewControllerの中でもSwiftUIでレイアウトが組める
                    SwiftUIView {
                        VStack {
                            Spacer()
                                .frame(height: 30)
                            Text("お　し　ま　い")
                                .font(.title)
                        }
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
                            self.user3.numberOfStars = max(0, self.user3.numberOfStars - 1)
                            self.user4.numberOfStars = max(0, self.user4.numberOfStars - 1)
                        }
                    )
                )

                UIButton(
                    configuration: .bordered().image(UIImage(systemName: "plus")!).cornerStyle(.capsule).contentInsets(.init(all: 16)),
                    primaryAction: .init(
                        handler: {[weak self] _ in
                            guard let self else { return }
                            // ObservableUIKitでデータ更新
                            self.user3.numberOfStars = min(5, self.user3.numberOfStars + 1)
                            self.user4.numberOfStars = min(5, self.user4.numberOfStars + 1)
                        }
                    )
                )
            }
            .spacing(16)
        }
    }
}


#Preview {
    ViewController()
}
