//
//  SwiftUIinUIKit.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/23.
//

import UIKit
import DeclarativeUIKit
import ObservableUIKit
import SwiftUI
import SwiftUIKit

final class SwiftUIinUIKitView: UIView {

    struct Delegate {
        var tapAction: () -> Void
    }

    var user: User?
    private var delegate: Delegate?

    convenience init(user: User?, delegate: Delegate? = nil) {
        self.init(frame: .null)

        self.user = user
        self.delegate = delegate

        self.declarative {
            // ここから中はSwiftUI
            SwiftUIView {
                Button {
                    self.delegate?.tapAction()
                } label: {
                    VStack(alignment: .leading) {
                        HStack {

                            Image(self.user?.iconName ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)


                            VStack {
                                Text(self.user?.name ?? "")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text(self.user?.accountName ?? "")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        }

                        HStack {
                            ForEach(0..<5) { index in
                                Image(index < self.user!.numberOfStars ? "star_fill" : "star")
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                            }
                        }

                        // ここから中はUIKit
                        UIKitView {
                            UITextView()
                                .tracking({[weak self] in
                                    self!.user?.message
                                }, onChange: { textView, message in
                                    textView.text(message)
                                })
                                .font(.systemFont(ofSize: 27, weight: .regular))
                                .isScrollEnabled(false)
                                .isEditable(false)
                                .contentPriorities(.init(vertical: .required))
                        }
                        .frame(height: 100)
                    }
                    .padding(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            }
        }
    }
}

#Preview(
    traits: .fixedLayout(width: 400, height: 300),
    body: {
        {
            let user = User.dummy1
            return SwiftUIinUIKitView(
                user: user,
                delegate: .init(
                    // タップしたらuser情報を更新
                    // viewはobservableによってSwiftUI/UIKit共に勝手に同期される
                    tapAction: {
                        user.minusNumberOfStars()
                })
            )
    }()
})
