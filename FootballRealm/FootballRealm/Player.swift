//
//  Player.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 4/17/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

enum Position: String {
    case GK, DEF, MID, ATTACK
}

class Player: Object {

    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var nid: String = ""
    dynamic var position: String = ""
    dynamic var team_id: String = ""



    dynamic var happiness: Float = 80.0
    dynamic var rating: Float = 0.0

    // Trait variables
    dynamic var hotheaded : Bool = false
    dynamic var oneClubMan : Bool = false
    dynamic var superStar : Bool = false
    dynamic var worldClass : Bool = false
    dynamic var diva : Bool = false
    dynamic var moneyMongrel : Bool = false
    dynamic var youngGun : Bool = false
    dynamic var prodigy : Bool = false
    dynamic var levelHeaded : Bool = false
    dynamic var injuryProne : Bool = false

    // Position traits
    dynamic var prolofic : Bool = false // Prolific attacker
    dynamic var pacher : Bool = false // Scores many goals
    dynamic var stalwart : Bool = false
    dynamic var creativeMastermind : Bool = false



//   dynamic var midfield_rating: Float = 0.0
//   dynamic var defense_rating: Float = 0.0
//  dynamic var goalkeeper_rating: Float = 0.0
//  dynamic var overall_rating: Float = 0.0
//  dynamic var league_id: String = ""

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    override static func primaryKey() -> String? {
        return "nid"
    }
    
    
    convenience init(firstName : String, surname : String, pos : String, overalRating : Float){
        self.init()
        self.firstName = firstName
        self.lastName = surname
        self.position = pos
        self.rating = overalRating

        let realm = try! Realm()
        // TODO: NEED TO CHECK CONTAINS, NOT ==
        let players = realm.objects(Player.self).filter("nid contains '" + firstName + "_" + surname + "'")
        if(players.count > 0){
            self.nid = firstName + "_" + surname + "_" + String(players.count)
        }else{
            self.nid = firstName + "_" + surname 
        }
    }
    
    
    // Getters
    func getRating()->Float{
        return self.rating
    }

    
    func getHappiness()->Float{
        return self.happiness
    }
    
    
    // Display functions
    func displayPlayer(){
        print(firstName + " " + lastName)
        print(position)
        print(rating)
        print("* * * * * * * * * * * * * *")
        
    }

}
