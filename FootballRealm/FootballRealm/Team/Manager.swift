//
//  Manager.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 11/26/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class Manager: Object {
    
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var nid: String = ""
    dynamic var team_id: String = ""
    
    
    dynamic var ratingCoaching : Float = 80.0 // How effective he is helping his players grow
    dynamic var ratingTactical : Float = 80.0 // How effective he is with match tactics
    dynamic var ratingTransfer : Float = 0.0 // How effective he is with transfers
    dynamic var ratingManManagement : Float = 60.0 // How effective he is with player happiness
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    
    override static func primaryKey() -> String? {
        return "nid"
    }
    
    
    convenience init(name : String, surname : String, coaching : Float, tactical : Float, transfer : Float, manManagement : Float){
        self.init()
        firstName = name
        lastName = surname
        ratingCoaching = coaching
        ratingTactical = tactical
        ratingTransfer = transfer
        ratingManManagement = manManagement
    }
    
    func getCoachingRating()->Float{ return ratingCoaching }
    func getTacticalRating()->Float{ return ratingTactical }
    func getTransferRating()->Float{ return ratingTransfer }
    func getManManagementRating()->Float{ return ratingManManagement }
}



