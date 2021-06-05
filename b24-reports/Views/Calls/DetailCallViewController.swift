//
//  DetailCallViewController.swift
//  b24-reports
//
//  Created by leomac on 21.04.2021.
//

import UIKit

class DetailCallViewController: UIViewController {

    //MARK: Private properties
    private enum UIConstants {
        static let topInset: CGFloat = 20
        static let leftRightInset: CGFloat = 16
        static let spacing: CGFloat = 20
    }
    
    var call: Call!
    
    lazy var lblNameManager = UIValueName("Manager")
    lazy var lblNameDate = UIValueName("Date")
    lazy var lblNameQtyIn = UIValueName("Q-ty In")
    lazy var lblNameQtyOut = UIValueName("Q-Ty Out")
    lazy var lblNameTimeIn = UIValueName("Time In")
    lazy var lblNameTimeOut = UIValueName("Time Out")

    lazy var lblManager = UILabel()
    lazy var lblDate = UILabel()
    lazy var lblQtyIn = UILabel()
    lazy var lblQtyOut = UILabel()
    lazy var lblTimeIn = UILabel()
    lazy var lblTimeOut = UILabel()
    
    private lazy var stackView_Main: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.stackView_Manager,
                                                       self.stackView_Date,
                                                       self.stackView_QtyIn,
                                                       self.stackView_QtyOut,
                                                       self.stackView_TimeIn,
                                                       self.stackView_TimeOut])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.spacing
        
        return stackView
    }()
    
    private lazy var stackView_Manager = horizontalStackView(subviews: [lblNameManager, lblManager])
    private lazy var stackView_Date = horizontalStackView(subviews: [lblNameDate, lblDate])
    private lazy var stackView_QtyIn = horizontalStackView(subviews: [lblNameQtyIn, lblQtyIn])
    private lazy var stackView_QtyOut = horizontalStackView(subviews: [lblNameQtyOut, lblQtyOut])
    private lazy var stackView_TimeIn = horizontalStackView(subviews: [lblNameTimeIn, lblTimeIn])
    private lazy var stackView_TimeOut = horizontalStackView(subviews: [lblNameTimeOut, lblTimeOut])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        if call != nil {
            lblManager.text = "\(call.manager!.firstName) \(call.manager!.lastName)"
            lblDate.text = call.dateFormated
            lblQtyIn.text = String(call.qtyIncomingCalls)
            lblQtyOut.text = String(call.qtyOutgoingCalls)
            lblTimeIn.text = String(call.timeOfIncoming)
            lblTimeOut.text = String(call.timeOfOutgoing)
        }
    }
    
    private func initialize() {
        view.addSubview(stackView_Main)
        stackView_Main.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(UIConstants.topInset)
            maker.leading.trailing.equalToSuperview().inset(UIConstants.leftRightInset)
        }
    }
    
    private func horizontalStackView(subviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.spacing
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }
}

class UIValueName: UILabel {
    
    init(_ name: String) {
        super.init(frame: .zero)
        self.text = name
        self.textColor = .placeholderText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

