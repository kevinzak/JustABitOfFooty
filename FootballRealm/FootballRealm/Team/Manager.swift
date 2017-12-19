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
    
    
    dynamic var mRatingCoaching : Float = 80.0 // How effective he is helping his players grow
    dynamic var mRatingTactical : Float = 80.0 // How effective he is with match tactics
    dynamic var mRatingTransfer : Float = 0.0 // How effective he is with transfers
    dynamic var mRatingManManagement : Float = 60.0 // How effective he is with player happiness
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    
    override static func primaryKey() -> String? {
        return "nid"
    }
    
    
    convenience init(name : String, surname : String, coaching : Float, tactical : Float, transfer : Float, manManagement : Float, idSeed : Int){
        self.init()
        firstName = name
        lastName = surname
        nid = name + "_" + surname + "_" + String(idSeed)
        mRatingCoaching = coaching
        mRatingTactical = tactical
        mRatingTransfer = transfer
        mRatingManManagement = manManagement
    }
    
    func getCoachingRating()->Float{ return self.mRatingCoaching }
    func getTacticalRating()->Float{ return self.mRatingTactical }
    func getTransferRating()->Float{ return self.mRatingTransfer }
    func getManManagementRating()->Float{ return self.mRatingManManagement }
    
    // Display functions
    func displayManager(){
        print(firstName + " " + lastName)
        print(mRatingCoaching)
        print(mRatingTactical)
        print(mRatingTransfer)
        print(mRatingManManagement)
        print("* * * * * * * * * * * * * *")
        
    }

    
}



