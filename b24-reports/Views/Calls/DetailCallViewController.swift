//
//  DetailCallViewController.swift
//  b24-reports
//
//  Created by leomac on 21.04.2021.
//

import UIKit

class DetailCallViewController: UIViewController {

    var call: Call!
    
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var qtyInLabel: UILabel!
    @IBOutlet weak var qtyOutLabel: UILabel!
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var timeOutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if call != nil {
            managerLabel.text = "\(call.manager!.firstName) \(call.manager!.lastName)"
            dateLabel.text = call.dateFormated
            qtyInLabel.text = String(call.qtyIncomingCalls)
            qtyOutLabel.text = String(call.qtyOutgoingCalls)
            timeInLabel.text = String(call.timeOfIncoming)
            timeOutLabel.text = String(call.timeOfOutgoing)
        }
        // Do any additional setup after loading the view.
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
