//
//  UserCardViewNormalCode.swift
//  LibraryDemo
//
//  Created by sakiyamaK on 2025/07/22.
//
import UIKit

final class UserCardViewNormalCode: UIView {

    struct Delegate {
        var tapAction: (UserCardViewNormalCode) -> Void
    }

    private let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        for _ in 0..<5 {
            let imageView = UIImageView(image: UIImage(systemName: "star"))
            imageView.contentMode = .scaleAspectFit
            imageView.setContentHuggingPriority(.required, for: .vertical)
            imageView.setContentHuggingPriority(.required, for: .horizontal)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 24, weight: .regular)
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private lazy var button: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        let button = UIButton(configuration: buttonConfig, primaryAction: .init(handler: {[weak self] _ in
            guard let self else { return }
            self.delegate?.tapAction(self)
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var user: User?
    private var delegate: Delegate?

    convenience init(user: User?, delegate: Delegate? = nil) {
        self.init(frame: .zero)

        self.user = user
        self.delegate = delegate

        self.setupLayout()
        self.setupConstraints()

        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray.cgColor

        if let user {
            self.config(user: user)
        }
    }

    private func setupLayout() {
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, accountLabel])
        nameStackView.axis = .vertical
        nameStackView.distribution = .fillEqually

        let iconNameStackView = UIStackView(arrangedSubviews: [iconView, nameStackView])
        iconNameStackView.axis = .horizontal
        iconNameStackView.spacing = 10

        mainStackView.addArrangedSubview(iconNameStackView)
        mainStackView.addArrangedSubview(starStackView)
        mainStackView.addArrangedSubview(textView)

        button.addSubview(mainStackView)

        addSubview(button)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 100),
            iconView.heightAnchor.constraint(equalToConstant: 100),
        ])

        NSLayoutConstraint.activate(
            starStackView.arrangedSubviews.compactMap({ $0 as? UIImageView }).compactMap({
                $0.widthAnchor.constraint(equalTo: $0.heightAnchor, multiplier: 1.0)
            })
        )

        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])
    }

    func config(user: User) {
        self.iconView.image = UIImage(named: user.iconName)
        self.nameLabel.text = user.name
        self.accountLabel.text = user.accountName
        for (i, imageView) in starStackView.arrangedSubviews.compactMap({ $0 as? UIImageView }).enumerated() {
            imageView.image = UIImage(named: i < user.numberOfStars ? "star_fill" : "star")
        }
        self.textView.text = user.message
    }
}

#Preview(
    traits: .fixedLayout(width: 400, height: 300),
    body: {
        {
            let user: User = User.dummy1

            let userCardView = UserCardViewNormalCode(
                user: user,
                delegate: .init(
                    // タップしたらuser情報を更新してviewを更新
                    tapAction: { userCardView in
                    var newUser: User = user
                    newUser.numberOfStars = max(0, user.numberOfStars - 1)
                    userCardView.config(user: newUser)
                })
            )

            return userCardView
    }()
})
