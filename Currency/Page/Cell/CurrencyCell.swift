//
//  CurrencyCell.swift
//  Currency
//
//  Created by kuanwei on 2022/5/11.
//

import Foundation
import UIKit

class CurrencyCell: UICollectionViewCell, ReusableViewCell {
    // MARK: Design
    private enum DesignGuide {
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let borderColor = UIColor.lightGray
        static let selectedBorderColor = UIColor.green
        static let textFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let verticalMargin: CGFloat = 11
        static let horizontalMargin: CGFloat = 16
    }

    // MARK: Properties
    var currencyName: String = "" {
        didSet {
            textLabel.text = currencyName
        }
    }

    var rate: Double = 0.0 {
        didSet {
            rateLabel.text = String(rate)
        }
    }

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ?
            DesignGuide.selectedBorderColor.cgColor :
            DesignGuide.borderColor.cgColor
        }
    }

    // MARK: UI Components
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = DesignGuide.textFont
        return label
    }()

    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = DesignGuide.textFont
        return label
    }()

    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    private func setupViews() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignGuide.verticalMargin),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignGuide.horizontalMargin),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignGuide.horizontalMargin),
        ])

        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rateLabel)
        NSLayoutConstraint.activate([
            rateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: DesignGuide.verticalMargin),
            rateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DesignGuide.verticalMargin),
            rateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignGuide.horizontalMargin),
            rateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignGuide.horizontalMargin),
        ])

        contentView.layer.cornerRadius = DesignGuide.cornerRadius
        contentView.layer.borderWidth = DesignGuide.borderWidth
        isSelected = false
    }
}
