//
//  CollectionViewCell.swift
//  b24-reports
//
//  Created by leomac on 24.06.2021.
//

import SnapKit
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    //MARK: Private properties
    private enum UIConstants {
        static let cellCornerRadius: CGFloat = 16
        static let titleFontSize: CGFloat = 14
        static let subtitleFontSize: CGFloat = 20
        static let topLeftInset: CGFloat = 12
        static let subtitleTopInset: CGFloat = 48
    }
    
    static let reusedID = "LoanOfferCollectionViewCell"
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: UIConstants.titleFontSize)
        //lbl.textColor = UIColor.Main.style
        return lbl
    }()
    
    private var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: UIConstants.subtitleFontSize)
        //lbl.textColor = UIColor.Main.accent1
        return lbl
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    private func initialize() {
        contentView.layer.cornerRadius = UIConstants.cellCornerRadius
//        contentView.layer.borderColor = UIColor.Main.accent1.cgColor
//        contentView.layer.borderWidth = 2
        //contentView.backgroundColor = UIColor.Main.background
        contentView.clipsToBounds = true
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(UIConstants.topLeftInset)
            maker.top.equalToSuperview().offset(UIConstants.topLeftInset)
        }
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(UIConstants.topLeftInset)
            maker.top.equalToSuperview().offset(UIConstants.subtitleTopInset)
        }
    }
    
    //MARK: Public methods
    public func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
}
