//
//  Team.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 11/20/16.
//  Copyright © 2016 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class Team: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    // Team Properties
    dynamic var nid: String = ""
    dynamic var name: String = ""
    dynamic var city: String = "Test City"
    dynamic var type: String = ""

    // Location (ground)
    dynamic var mGround : LocationModel!
    
    // League Properties
    dynamic var league_id: String = ""
    
    // Ratings
    dynamic var attack_rating: Float = 0.0
    dynamic var midfield_rating: Float = 0.0
    dynamic var defense_rating: Float = 0.0
    dynamic var goalkeeper_rating: Float = 0.0
    dynamic var overall_rating: Float = 0.0
    dynamic var home_advantage: Float = 5.0
    
    // Formation
    dynamic private var mNumStartingGoalkeepers : Int = 1
    dynamic private var mNumStartingDefenders : Int = 4
    dynamic private var mNumStartingMidfielders : Int = 4
    dynamic private var mNumStartingAttackers : Int = 2
    
    
    // Stats
    dynamic private var league_titles: Int = 0
    dynamic private var promotions: Int = 0
    dynamic private var relegations: Int = 0

    // Flags set at the beginning and end of each season to determine how 
    // being relegated or promoted effects their transfer business
    var                 isPromoted = false;
    var                 isRelegated = false;
    
    // Players
    var mGoalkeepers = List<Player>()
    var mDefenders = List<Player>()
    var mMidfielders = List<Player>()
    var mAttackers = List<Player>()
    
    // Manager
    dynamic var mManager : Manager!
    
    override static func primaryKey() -> String? {
        return "nid"
    }
    
    convenience init(id : String, name : String, attack : Float, midfield : Float, defense : Float, goalkeeper : Float){
        self.init()
        populateData()
        
        self.name = name
        self.nid = id
        
        self.attack_rating = attack
        self.midfield_rating = midfield
        self.defense_rating = defense
        self.goalkeeper_rating = goalkeeper
        
        generateTeam()
    }
    
    private func generateTeam(){
        mManager = ManagerFactory.sharedInstance.generateManager(20) // Generate with default amount
        mGoalkeepers = PlayerFactory.sharedInstance.generateGoalkeepers() // Generate with default amount
        mDefenders = PlayerFactory.sharedInstance.generateDefenders() // Generate with default amount
        mMidfielders = PlayerFactory.sharedInstance.generateMidfielders() // Generate with default amount
        mAttackers = PlayerFactory.sharedInstance.generateAttackers() // Generate with default amount
        
        print(name + "'s generated team")
        var goalkeeperRating :Float = 0.0
        var defenderRating :Float = 0.0
        var midfielderRating :Float = 0.0
        var attackerRating :Float = 0.0

        
        // Show Manager
        print("Manager:")
        mManager.displayManager()
        
        // Make Goalkeepers
        for(var i = 0; i < mGoalkeepers.count; i++){
            mGoalkeepers[i].displayPlayer()
            goalkeeperRating += mGoalkeepers[i].getRating()
        }
        self.goalkeeper_rating = goalkeeperRating/Float(mGoalkeepers.count)
        
        // Make Defenders
        for(var i = 0; i < mDefenders.count; i++){
            mDefenders[i].displayPlayer()
            defenderRating += mDefenders[i].getRating()

        }
        self.defense_rating = defenderRating/Float(mDefenders.count)

        // Make Midfielders
        for(var i = 0; i < mMidfielders.count; i++){
            mMidfielders[i].displayPlayer()
            midfielderRating += mMidfielders[i].getRating()
        }
        self.midfield_rating = midfielderRating/Float(mMidfielders.count)
        
        // Make Attackers
        for(var i = 0; i < mAttackers.count; i++){
            mAttackers[i].displayPlayer()
            attackerRating += mAttackers[i].getRating()
        }
        
        
        self.attack_rating = attackerRating/Float(mAttackers.count)


        self.overall_rating = (Float(self.attack_rating) + Float(self.midfield_rating) + Float(self.defense_rating) + Float(self.goalkeeper_rating))/4

        print()
        displayRatings()
        print()
        


    }
    
    // Sets base
    func populateData(){
        self.name = "";
        self.nid  = ""
        self.overall_rating = 0.0;
        self.attack_rating = 0.0;
        self.midfield_rating = 0.0;
        self.defense_rating = 0.0;
        self.goalkeeper_rating = 0.0;
        
        self.league_titles = 0
        self.promotions = 0
        self.relegations = 0
        
    }
    
    
    /* * * * * * * * * * * * * * */
    /*          Getters          */
    /* * * * * * * * * * * * * * */
    // Get Club Properties
    func getName()->String { return name }
    func getId()->String { return nid }
    func getCity()->String { return city }
    func getClubType()->String { return type }

    // Location Propertiers
    func getGround()->LocationModel{ return mGround; }
    func getGroundName()->String{ return mGround.getName(); }
    func getGroundId()->String{ return mGround.getId(); }
    func getGroundType()->String{ return mGround.getType(); }
    func getGroundPitchQuality()->Float{ return mGround.getPitchQuality(); }
    func getGroundAccessibility()->Float{ return mGround.getAccessibility(); }
    func getGroundAreaDesirability()->Float{ return mGround.getAreaDesirability(); }
    
    // Get League Properties
    func getLeagueId()->String { return league_id }
    
    // Get Ratings
    func getOverallRating()->Float { return Float(self.overall_rating) }
    func getAttackRating()->Float { return Float(attack_rating) }
    func getMidfieldRating()->Float { return Float(midfield_rating) }
    func getDefenseRating()->Float { return Float(defense_rating) }
    func getGoalkeeperRating()->Float { return Float(goalkeeper_rating) }
    func getHomeAdvantage()->Float { return Float(home_advantage) }
    
    /* * * * * * * * * * * * * * */
    /*          Setters          */
    /* * * * * * * * * * * * * * */
    // Set Club Properties
    func setTeamName(name : String) { self.name = name }
    func setTeamId(tId : String) { self.nid = tId }
    func setTeamCity(cityName : String) { self.city = cityName}
    func setTeamType(clubType : String) { self.type = clubType }
    
    // Set Ground Properties
    func setGround(ground : LocationModel) { self.mGround = ground; }

    // Set Manager Properties
    func setManager(manager : Manager) { self.mManager = manager; }

    // Set League Properties
    func setLeagueId(league : String) { self.league_id = league }

    // Set ratings
    func setAttackRating(attack : Float) { self.attack_rating = attack }
    func setMidfieldRating(midfield : Float) { self.midfield_rating = midfield }
    func setDefenseRating(defense : Float) { self.defense_rating = defense }
    func setGoalkeeperRating(goalkeeper : Float) { self.goalkeeper_rating = goalkeeper }
    
    func setOverallRating() {
        self.overall_rating = (Float(self.attack_rating) + Float(self.midfield_rating) + Float(self.defense_rating) + Float(self.goalkeeper_rating))/4
    }
    
    
    /* * * * * * * * * * * * * * */
    /*      Update Functions     */
    /* * * * * * * * * * * * * * */
    private func updateAttackRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {
            var newAttackRating = Float(attack_rating) + updateAmt;
            if(newAttackRating > 100){
                newAttackRating = 100
            }else if(newAttackRating < 50){
                newAttackRating = 50
            }
            self.attack_rating = newAttackRating
        }
    }
    
    private func updateMidfieldkRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {
            var newMidRating = Float(midfield_rating) + updateAmt;
            if(newMidRating > 100){
                newMidRating = 100
            }else if(newMidRating < 50){
                newMidRating = 50
            }

            self.midfield_rating = newMidRating
        }
    }

    private func updateDefenseRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {
            var newDefRating = Float(defense_rating) + updateAmt;
            if(newDefRating > 100){
                newDefRating = 100
            }else if(newDefRating < 50){
                newDefRating = 50
            }

            self.defense_rating = newDefRating
        }
    
    }

    private func updateGoalkeeperRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {
            var newGKRating = Float(goalkeeper_rating) + updateAmt;
            if(newGKRating > 100){
                newGKRating = 100
            }else if(newGKRating < 50){
                newGKRating = 50
            }

            self.goalkeeper_rating = newGKRating
        }
    }
    
    
    /* * * * * * * * * * * * * * */
    /*  Updating Stat Functions  */
    /* * * * * * * * * * * * * * */
    // Adding stats
    func addTrophy(){
        
    }
    
    func addLeagueTitle(){
        let realm = try! Realm()
        try! realm.write {
            self.league_titles = Int(league_titles) + 1
        }
    }
    
    func addPromotion(){
        let realm = try! Realm()
        try! realm.write {
            self.promotions = Int(promotions) + 1
        }
    }
    
    func addRelegation(){
        let realm = try! Realm()
        try! realm.write {
            self.relegations = Int(relegations) + 1
        }
    }
    
    func setPromotedBoolean(){
        isPromoted = true;
    }
    
    func setRelegatedBoolean(){
        isRelegated = false;
    }

    func resetTeamSeason(){
        isPromoted = false
        isRelegated = false
    }
 
    
    /* * * * * * * * * * * * * * */
    /*     Transfer Functions    */
    /* * * * * * * * * * * * * * */

    //  Controlled by what league you're in and if you went from league to league
    //  For example, a team going from Premier League to championship will probably lose it's good players
    //  While a team getting promoted to the Prem will invest in good players, improving their maxAddition
    func transferBusiness(maxAdditon : Int, maxSubtraction : Int){
        var maximumAdditon = maxAdditon
        var maximumSubtraction = maxSubtraction
        
        // Adjust max addition and subtraction if team is newly promoted or relegated
        if(isPromoted){
            maximumAdditon = maxAdditon + 3
        }else if(isRelegated){
            maximumSubtraction = maxSubtraction + 3
        }
        
        
        let atkImprovements = Float(arc4random_uniform(UInt32(maximumAdditon)))
        let atkDeficate = Float(arc4random_uniform(UInt32(maximumSubtraction)))
        let atkDif = -atkDeficate + atkImprovements;
        
        let midImprovements = Float(arc4random_uniform(UInt32(maximumAdditon)))
        let midDeficate = Float(arc4random_uniform(UInt32(maximumSubtraction)))
        let midDif = -midDeficate + midImprovements;
        
        let defImprovements = Float(arc4random_uniform(UInt32(maximumAdditon)))
        let defDeficate = Float(arc4random_uniform(UInt32(maximumSubtraction)))
        let defDif = -defDeficate + defImprovements;
        
        let glkImprovements = Float(arc4random_uniform(UInt32(maximumAdditon)))
        let glkDeficate = Float(arc4random_uniform(UInt32(maximumSubtraction)))
        let glkDif = -glkDeficate + glkImprovements;
        
        updateAttackRating(atkDif)
        updateMidfieldkRating(midDif)
        updateDefenseRating(defDif)
        updateGoalkeeperRating(glkDif)
    }
    
    // TODO: Update Staff?

    
    /* * * * * * * * * * * * * * */
    /*     Match  Functions      */
    /* * * * * * * * * * * * * * */
    func getManager()->Manager{
        return self.mManager
    }
    

    func getStartingKeepers()->[Player]{
        let sortedKeepers = mGoalkeepers.sort { t1, t2 in
            if t1.isAvailable() == t2.isAvailable() { return t1.rating > t2.rating }
         
            return t1.isAvailable() && !t2.isAvailable()
        }
        
        var startingKeepers : [Player] = [];
        for(var i = 0; i < mNumStartingGoalkeepers; i++){
            startingKeepers.append(sortedKeepers[i])
        }
        
        return startingKeepers;
    }

    func getStartingDefenders()->[Player]{
        let sortedDefenders = mDefenders.sort { t1, t2 in
            if t1.isAvailable() == t2.isAvailable() { return t1.rating > t2.rating }
            
            return t1.isAvailable() && !t2.isAvailable()
        }

        var startingDefenders : [Player] = [];
        for(var i = 0; i < mNumStartingDefenders; i++){
            startingDefenders.append(sortedDefenders[i])
        }
        
        return startingDefenders;

    }
    
    func getStartingMidfielders()->[Player]{
        let sortedMidfielders = mMidfielders.sort { t1, t2 in
            if t1.isAvailable() == t2.isAvailable() { return t1.rating > t2.rating }
            
            return t1.isAvailable() && !t2.isAvailable()
        }

        var startingMidfielders : [Player] = [];
        for(var i = 0; i < mNumStartingMidfielders; i++){
            startingMidfielders.append(sortedMidfielders[i])
        }
        
        return startingMidfielders;
    }
    
    func getStartingAttackers()->[Player]{
        let sortedAttackers = mAttackers.sort { t1, t2 in
            if t1.isAvailable() == t2.isAvailable() { return t1.rating > t2.rating }
            
            return t1.isAvailable() && !t2.isAvailable()
        }
        
        var startingAttackers : [Player] = [];
        for(var i = 0; i < mNumStartingAttackers; i++){
            startingAttackers.append(sortedAttackers[i])
        }
        
        return startingAttackers;
    }

    /* * * * * * * * * * * * * * */
    /*     Display Functions     */
    /* * * * * * * * * * * * * * */
    func displayStats(){
        print(name)
        print("League Titles: " + String(self.league_titles))
        print("Promotions: " + String(self.promotions))
        print("Relegations: " + String(self.relegations))
        
    }

    func displayManagers(){
        print(name)
        print("---Manager---")
        self.mManager.displayManager()
    }
    
    func displayPlayers(){
        print(name)
        print("---Goalkeepers---")
        for(var i = 0; i < mGoalkeepers.count; i++){
            mGoalkeepers[i].displayPlayer()
        }
        print("")
        print("---Defenders---")
        for(var i = 0; i < mDefenders.count; i++){
            mDefenders[i].displayPlayer()
        }
        print("")
        print("---Midfielders---")
        for(var i = 0; i < mMidfielders.count; i++){
            mMidfielders[i].displayPlayer()
        }
        print("")
        print("---Attackers---")
        for(var i = 0; i < mAttackers.count; i++){
            mAttackers[i].displayPlayer()
        }
                
    }
    
    func displayRatings(){
        print(name)
        print("Overall: " + String(self.overall_rating))
        print("GK: " + String(self.goalkeeper_rating))
        print("DEF: " + String(self.defense_rating))
        print("MID: " + String(self.midfield_rating))
        print("ATTACK: " + String(self.attack_rating))        
    }


}
