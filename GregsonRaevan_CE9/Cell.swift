//
//  Cell.swift
//  GregsonRaevan_CE9
//
//  Created by Raevan Gregson on 12/14/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var recipientsLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
