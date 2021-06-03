//
//  CallsTableViewCell.swift
//  b24-reports
//
//  Created by leomac on 14.04.2021.
//

import UIKit

class CallsTableViewCell: UITableViewCell {

    //MARK: Private properties
    private enum UIConstants {
        static let inset: CGFloat = 10
        static let width: CGFloat = 200
        static let spacing: CGFloat = 5
        static let fontSize: CGFloat = 15
    }
    
    private lazy var stackView_Main: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.manager, self.stackView_Calls])
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.spacing
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()

    private lazy var stackView_Calls: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.stackView_In, self.stackView_Out])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.spacing
        
        return stackView
    }()
    
    private lazy var stackView_In: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.qtyIn, self.qtyIncomingCalls])
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.spacing
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var stackView_Out: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.qtyOut, self.qtyOutgoingCalls])
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.spacing
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    lazy var manager: UILabel = {
        let lbl = UILabel()
        
        return lbl
    }()
    
    lazy var qtyIn: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Arial", size: UIConstants.fontSize)
        lbl.textColor = .placeholderText
        lbl.text = "q-ty In"
        
        return lbl
    }()
    
    lazy var qtyIncomingCalls: UILabel = {
        let lbl = UILabel()
        
        return lbl
    }()
    
    lazy var qtyOut: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Arial", size: UIConstants.fontSize)
        lbl.textColor = .placeholderText
        lbl.text = "q-ty Out"
        
        return lbl
    }()
    
    lazy var qtyOutgoingCalls: UILabel = {
        let lbl = UILabel()
        
        return lbl
    }()
        
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    private func initialize() {
        contentView.addSubview(stackView_Calls)
        stackView_Calls.snp.makeConstraints { maker in
            maker.top.bottom.trailing.equalToSuperview().inset(UIConstants.inset)
            maker.width.equalTo(UIConstants.width)
        }
        
        contentView.addSubview(manager)
        manager.snp.makeConstraints { maker in
            maker.top.bottom.leading.equalToSuperview().inset(UIConstants.inset)
            maker.width.equalTo(UIConstants.width)
        }
    }
}
