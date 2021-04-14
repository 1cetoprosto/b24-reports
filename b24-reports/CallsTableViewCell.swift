//
//  CallsTableViewCell.swift
//  b24-reports
//
//  Created by leomac on 14.04.2021.
//

import UIKit

class CallsTableViewCell: UITableViewCell {

    @IBOutlet weak var manager: UILabel!
    @IBOutlet weak var qtyIncomingCalls: UILabel!
    @IBOutlet weak var qtyOutgoingCalls: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
