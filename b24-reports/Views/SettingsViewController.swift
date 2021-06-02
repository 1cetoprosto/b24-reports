//
//  SettingsViewController.swift
//  b24-reports
//
//  Created by leomac on 13.04.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var updateData: UIButton!
    
    @IBAction func updateDataAction(_ sender: UIButton) {
        loadManagersFromCloud()
        loadCallsFromCloud()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateData.layer.cornerRadius = CGFloat(5)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
