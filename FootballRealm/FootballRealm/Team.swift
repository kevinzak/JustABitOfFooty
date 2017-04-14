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
    dynamic var name: String = ""
    dynamic var nid: String = ""
    dynamic var attack_rating: Float = 0.0
    dynamic var midfield_rating: Float = 0.0
    dynamic var defense_rating: Float = 0.0
    dynamic var goalkeeper_rating: Float = 0.0
    dynamic var overall_rating: Float = 0.0
    dynamic var league_id: String = ""
    
//    dynamic private var wins: Int = 0
//    dynamic private var draws: Int = 0
//    dynamic private var loses: Int = 0
//    dynamic private var goals_against: Int = 0
//    dynamic private var goals_for: Int = 0
//    dynamic private var matches_played: Int = 0
//    dynamic private var points: Int = 0
    
    dynamic private var league_titles: Int = 0
    dynamic private var promotions: Int = 0
    dynamic private var relegations: Int = 0
    
    override static func primaryKey() -> String? {
        return "nid"
    }

    
    convenience init(name : String, attack : Float, midfield : Float, defense : Float, goalkeeper : Float){
        self.init()
        populateData()
        
        self.name = name
        self.nid = name
        
        self.attack_rating = attack
        self.midfield_rating = midfield
        self.defense_rating = defense
        self.goalkeeper_rating = goalkeeper
        
        self.overall_rating = (Float(self.attack_rating) + Float(self.midfield_rating) + Float(self.defense_rating) + Float(self.goalkeeper_rating))/4
        
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
        
//        self.matches_played = 0
//        self.wins = 0
//        self.loses = 0
//        self.draws = 0
//        self.goals_for = 0
//        self.goals_against = 0
//        self.points = 0
        
        self.league_titles = 0
        self.promotions = 0
        self.relegations = 0
        
    }
    
    func getName()->String { return name }
    func getId()->String { return nid }
    func getOverallRating()->Float { return Float(self.overall_rating) }
    func getAttackRating()->Float { return Float(attack_rating) }
    func getMidfieldRating()->Float { return Float(midfield_rating) }
    func getDefenseRating()->Float { return Float(defense_rating) }
    func getGoalkeeperRating()->Float { return Float(goalkeeper_rating) }
    
    func setTeamName(name : String) { self.name = name }
    func setId(tId : String) { nid = tId }
    func setAttackRating(attack : Float) { self.attack_rating = attack }
    func setMidfieldRating(midfield : Float) { self.midfield_rating = midfield }
    func setDefenseRating(defense : Float) { self.defense_rating = defense }
    func setGoalkeeperRating(goalkeeper : Float) { self.goalkeeper_rating = goalkeeper }
    
    func setOverallRating() {
        self.overall_rating = (Float(self.attack_rating) + Float(self.midfield_rating) + Float(self.defense_rating) + Float(self.goalkeeper_rating))/4
    }

    private func updateAttackRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {
            self.attack_rating = Float(attack_rating) + updateAmt
        }
    }
    
    private func updateMidfieldkRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {
            self.midfield_rating = Float(midfield_rating) + updateAmt
        }
    }

    private func updateDefenseRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {
            self.defense_rating = Float(defense_rating) + updateAmt
        }
    
    }
    private func updateGoalkeeperRating(updateAmt : Float){
        let realm = try! Realm()
        try! realm.write {

            self.goalkeeper_rating = Float(self.goalkeeper_rating) + updateAmt
        }
    }
    
    //  Table functions
//    func setMatchesPlayed(mp : Int){ self.matches_played = mp }
//    func setTeamWins(wins : Int){ self.wins = wins }
//    func setTeamLoses(loses : Int){ self.wins = loses }
//    func setTeamDraws(draws : Int){ self.draws = draws }
//    func setTeamGoalsFor(gf : Int){ self.goals_for = gf }
//    func setTeamGoalsAgainst(ga : Int){ self.goals_against = ga }
//    func setTeamPoints(pts : Int){ self.points = pts }
    
//    func getMatchesPlayed()->Int{ return Int(self.matches_played); }
//    func getWins()->Int{ return Int(self.wins); }
//    func getLoses()->Int{ return Int(loses); }
//    func getDraws()->Int{ return Int(draws); }
//    func getGoalsFor()->Int{ return Int(goals_for); }
//    func getGoalsAgainst()->Int{ return Int(goals_against); }
//    func getPoints()->Int{ return Int(points); }
    
//    func addMatchPlayed(){ self.matches_played = Int(matches_played) + 1 }
//    func addGoalsFor(goals : Int){ self.goals_for = Int(goals_for) + goals }
//    func addGoalsAgainst(goals : Int){ goals_against = Int(goals_against) + goals }
//    func addPoints(pts : Int){ points = Int(points) + pts }
    
    // Adding stats
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
    
//    func addLoss(){
//        addMatchPlayed()
//        self.loses = Int(loses) + 1
//    }
//    
//    func addWin(){
//        addMatchPlayed()
//        self.wins = Int(wins) + 1
//        addPoints(3)
//        
//    }
//    
//    func addDraw(){
//        addMatchPlayed()
//        self.draws = Int(draws) + 1
//        addPoints(1)
//
//    }

    func resetTeamSeason(){
//        setMatchesPlayed(0)
//        setTeamWins(0)
//        setTeamLoses(0)
//        setTeamDraws(0)
//        setTeamGoalsFor(0)
//        setTeamGoalsAgainst(0)
//        setTeamPoints(0)
    }
    
    func displayStats(){
        print(name)
        print("League Titles: " + String(self.league_titles))
        print("Promotions: " + String(self.promotions))
        print("Relegations: " + String(self.relegations))
        
    }

    func displayRatings(){
        print(name)
        print("Overall: " + String(self.overall_rating))
        print("GK: " + String(self.goalkeeper_rating))
        print("DEF: " + String(self.defense_rating))
        print("MID: " + String(self.midfield_rating))
        print("ATTACK: " + String(self.attack_rating))        
    }

    //  Controlled by what league you're in and if you went from league to league
    //  For example, a team going from Premier League to championship will probably lose it's good players
    //  While a team getting promoted to the Prem will invest in good players, improving their maxAddition
    func transferBusiness(maxAdditon : Int, maxSubtraction : Int){
        let atkImprovements = Float(arc4random_uniform(UInt32(maxAdditon)))
        let atkDeficate = Float(arc4random_uniform(UInt32(maxSubtraction)))
        let atkDif = -atkDeficate + atkImprovements;
        
        let midImprovements = Float(arc4random_uniform(UInt32(maxAdditon)))
        let midDeficate = Float(arc4random_uniform(UInt32(maxSubtraction)))
        let midDif = -midDeficate + midImprovements;
        
        let defImprovements = Float(arc4random_uniform(UInt32(maxAdditon)))
        let defDeficate = Float(arc4random_uniform(UInt32(maxSubtraction)))
        let defDif = -defDeficate + defImprovements;
        
        let glkImprovements = Float(arc4random_uniform(UInt32(maxAdditon)))
        let glkDeficate = Float(arc4random_uniform(UInt32(maxSubtraction)))
        let glkDif = -glkDeficate + glkImprovements;
        
        updateAttackRating(atkDif)
        updateMidfieldkRating(midDif)
        updateDefenseRating(defDif)
        updateGoalkeeperRating(glkDif)
    }
    
    // TODO: Update Staff?


}
