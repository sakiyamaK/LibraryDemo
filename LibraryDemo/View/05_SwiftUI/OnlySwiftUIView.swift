//
//  OnlySwiftUIView.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/27.
//

import SwiftUI

struct OnlySwiftUIView: View {

    struct Delegate {
        var tapAction: () -> Void
    }

    @Bindable var user: User
    var delegate: Delegate?

    var body: some View {
        Button {
            delegate?.tapAction()
        } label: {
            VStack(alignment: .leading) {
                HStack {

                    Image(self.user.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)


                    VStack {
                        Text(self.user.name)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text(self.user.accountName)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }

                HStack {
                    ForEach(0..<5) { index in
                        Image(index < self.user.numberOfStars ? "star_fill" : "star")
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                }

                TextEditor(text: $user.message)
                    .font(.system(size: 27, weight: .regular))
                    .disabled(true)
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

#Preview(
    traits: .fixedLayout(width: 400, height: 300),
    body: {
        {
            let user = User.dummy1

            return OnlySwiftUIView(
                user: user,
                delegate: .init(
                    tapAction: {
                        user.minusNumberOfStars()
                })
            )
    }()
})
