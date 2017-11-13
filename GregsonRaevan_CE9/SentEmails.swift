//
//  SentEmails.swift
//  GregsonRaevan_CE9
//
//  Created by Raevan Gregson on 12/18/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import Foundation

class SentEmails{
    var email = [String]()
    var timeStamp:String?
    
    init(email:[String], timeStamp:String){
        self.email = email
        self.timeStamp = timeStamp
        
    }
    init(email:[String]){
        self.email = email
    }
    init(){
    }
    
}
