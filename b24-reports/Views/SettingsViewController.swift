//
//  SettingsViewController.swift
//  b24-reports
//
//  Created by leomac on 13.04.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: Private properties
    private enum UIConstants {
        static let height: CGFloat = 50
        static let width: CGFloat = 150
        static let cornerRadius: CGFloat = 5
        static let fontSize: CGFloat = 15
    }
    
    private lazy var updateData: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = CGFloat(UIConstants.cornerRadius)
        btn.setTitle("Update Data", for: .normal)
        btn.addTarget(self, action: #selector(updateDataAction), for: .touchUpInside)

        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    @objc func updateDataAction(sender: UIButton!) {
        loadManagersFromCloud()
        loadCallsFromCloud()
    }
    
    private func initialize() {
        view.backgroundColor = .white
        view.addSubview(updateData)
        updateData.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalTo(UIConstants.width)
            maker.height.equalTo(UIConstants.height)
        }
    }
}
