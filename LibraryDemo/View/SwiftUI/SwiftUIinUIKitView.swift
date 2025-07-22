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
        self.init(frame: .zero)

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
                                .frame(width: 50, height: 50)


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
                                    .aspectRatio(contentMode: .fit)
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
                                .isScrollEnabled(true)
                                .isEditable(false)
                                .contentPriorities(.init(vertical: .required))
                                .height(200)
                        }
                    }
                    .clipShape(.rect(cornerRadius: 16))
                    .border(Color.gray, width: 1)
                }
            }
        }
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 300), body: {
    {
        let user = User.dummy1
        return SwiftUIinUIKitView(user: user, delegate: .init(tapAction: {
            user.numberOfStars = max(0, user.numberOfStars - 1)
        }))
    }()
})
