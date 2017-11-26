//
//  LocationModel.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 5/20/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class LocationModel: Object {
    dynamic var mName: String = ""
    dynamic var mSeating: String = "" // On Top of Pitch, Close to Pitch, Standard Distance, Track Around Pitch
    dynamic var mType: String = "" // Industrial (yards) (road) (court), affluent (bridge?) (court) (way) (street), residential (road) (cottage) (lane) (way) (street), swamplands (moor), countryside (grounds) (meadow), forrested area, park area (park)
    dynamic var mId: String = ""

    dynamic var mDesireabilityOfArea: Float = 0.0
    dynamic var mPitchQuality: Float = 0.0
    dynamic var mAccessibilty: Float = 0.0
    dynamic var mHomeAdvantage: Float = 5.0

    // Trait variables
//    dynamic var hotheaded : Bool = false
//    dynamic var oneClubMan : Bool = false

    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }

    
    convenience init(name : String, type : String, area : Float, pitch : Float, access : Float){
        self.init()
        mId = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        mName = name
        mType = type
        mDesireabilityOfArea = area
        mPitchQuality = pitch
        mAccessibilty = access
    }
    
    func getName()->String{
        return mName
    }
    func getType()->String{
        return mType
    }
    func getId()->String{
        return mId
    }
    func getAreaDesirability()->Float{
        return mDesireabilityOfArea
    }
    func getPitchQuality()->Float{
        return mPitchQuality
    }
    func getAccessibility()->Float{
        return mAccessibilty
    }
    func getHomeAdvantage()->Float{
        return mHomeAdvantage
    }
}


