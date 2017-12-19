//
//  Fixture.swift
//  JustABitOfFooty
//
//  Created by Kevin Zakszewski on 8/5/15.
//  Copyright (c) 2015 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class Fixture: Object {

    enum FixtureResult{
        case HOME_WIN
        case AWAY_WIN
        case DRAW
    }
    
    //TODO: Implement fixture date

    dynamic var gameWeek = -1
    dynamic var leagueId = ""
    dynamic var fixtureId = ""

    dynamic var homeTeamId : String?
    dynamic var awayTeamId : String?

    dynamic var homeTeamDisplayName : String?
    dynamic var awayTeamDisplayName : String?
    
    dynamic var winningTeam : Team?
    dynamic var losingTeam : Team?
    
    dynamic var homeGoals = -1
    dynamic var awayGoals = -1
    
    var fixtureResult : FixtureResult?
    
    override static func primaryKey() -> String? {
        return "fixtureId"
    }

    
    convenience init(home : Team, away : Team, id : String, week : Int){
        self.init()
        self.gameWeek = week
        self.leagueId = id
        self.homeTeamId = home.getId()
        self.awayTeamId = away.getId()
        
        self.homeTeamDisplayName = home.getName()
        self.awayTeamDisplayName = away.getName()

        self.fixtureId = home.getId() + "_" + away.getId() + "_" + id + "_" + String(week)
    }
    
    func playMatch(printFixtr : Bool = false){
        let realm = try! Realm()
        
        try! realm.write {
            self.homeGoals = 0
            self.awayGoals = 0
        
            // TODO: Implement match algorithm
            playFixture()
        
            setFixtureResult()


            updateTeamsFromResult()
        }
        
        if(printFixtr){
            printFixture()
        }
    }
    
    func setFixtureResult(){
        if(homeGoals == awayGoals){
            fixtureResult = FixtureResult.DRAW
        }else if(homeGoals > awayGoals){
            fixtureResult = FixtureResult.HOME_WIN
        }else{
            fixtureResult = FixtureResult.AWAY_WIN
        }
    }
    
    func getResult()->FixtureResult{ return fixtureResult! }
    
    func getHomeScore()->Int { return homeGoals }
    func getAwayScore()->Int { return awayGoals }
    
    
    /*
    Attack
    Midfield
    Defense
    OWN GOALS - 2%
    */
    
    private func playFixture(){
        let realm = try! Realm()
        let homeTeam = realm.objects(Team.self).filter("nid == '" + self.homeTeamId! + "'").first
        let awayTeam = realm.objects(Team.self).filter("nid == '" + self.awayTeamId! + "'").first
        
        // Gets the rating fo the teams for calculation
        let homeAdv = (homeTeam?.getHomeAdvantage())!
        
        let homeManRating = homeTeam?.getManager().getTacticalRating()
        let awayManRating = awayTeam?.getManager().getTacticalRating()
        
        let homeGlk = getPositionRating((homeTeam?.getStartingKeepers())!)
        let awayGlk = getPositionRating((awayTeam?.getStartingKeepers())!)

        let homeDef = getPositionRating((homeTeam?.getStartingDefenders())!)
        let awayDef = getPositionRating((awayTeam?.getStartingDefenders())!)

        let homeMid = getPositionRating((homeTeam?.getStartingMidfielders())!)
        let awayMid = getPositionRating((awayTeam?.getStartingMidfielders())!)

        let homeAtk = getPositionRating((homeTeam?.getStartingAttackers())!)
        let awayAtk = getPositionRating((awayTeam?.getStartingAttackers())!)
        
        let homeOvr = (homeAtk + homeMid + homeDef + homeGlk)/4
        let awayOvr = (awayAtk + awayMid + awayDef + awayGlk)/4
        
/*        let homeGKString = "Home GK - " + String(homeGlk)
        let awayGKString = "Away GK - " + String(awayGlk)
        let homeDEFString = "Home Def - " + String(homeDef)
        let awayDEFString = "Away Def - " + String(awayDef)
        let homeMIDString = "Home Mid - " + String(homeMid)
        let awayMIDString = "Away Mid - " + String(awayMid)
        let homeATKString = "Home Atk - " + String(homeAtk)
        let awayATKString = "Away Atk - " + String(awayAtk)
        let homeOverallString = "Home Overall - " + String(homeOvr)
        let awayOverallString = "Away Overall - " + String(awayOvr)

        print(homeGKString)
        print(awayGKString)
        print(homeDEFString)
        print(awayDEFString)
        print(homeMIDString)
        print(awayMIDString)
        print(homeATKString)
        print(awayATKString)
        print(homeOverallString)
        print(awayOverallString)
 */
        
        // Gets the rating fo the teams for calculation
        
/*        let homeMid = homeTeam?.getMidfieldRating()
        let awayMid = awayTeam?.getMidfieldRating()
        
        let homeAtk = homeTeam?.getAttackRating()
        let awayAtk = awayTeam?.getAttackRating()
        
        let homeDef = homeTeam?.getDefenseRating()
        let awayDef = awayTeam?.getDefenseRating()
        
        let homeGlk = homeTeam?.getGoalkeeperRating()
        let awayGlk = awayTeam?.getGoalkeeperRating()
*/
        
        // Base for formula on how chancces are created
        let homeChance = homeAdv + homeMid + homeAtk + homeManRating!
        let awayChance = awayMid + awayAtk + awayManRating!
        
        let homeChanceBase = (homeChance) + awayChance
        let awayChanceBase = (awayChance) + homeChance
        
        // Gives rating of chance creation - percentage of ones MID and ATK vs opponent's MID and DEF
        // AKA - Who's ones ATK vs DEF and vice versa
        let homeChanceTotal = ((homeChance) / homeChanceBase) * 100
        let awayChanceTotal = ((awayChance) / awayChanceBase) * 100
        
        //Percentage/chance the teams will create a scoring opportunity
        //The - 0.075 creates a 15% chance neither team will create a scoring opportunity
        let homeChancePercent = (homeChanceTotal) / (homeChanceTotal + awayChanceTotal) - 0.075
        let awayChancePercent = (awayChanceTotal) / (homeChanceTotal + awayChanceTotal) - 0.075
        
        //Values used when random number is generated for scoring opporunity
        //Between midfloor and midCeil represents the 15% chance that no one makes a scoring opportunity
        let midFloor = Int(homeChancePercent * 1000)
        let midCeil = 1000 - Int(awayChancePercent * 1000)

        if(midFloor >= midCeil){
            print("This soundn't be....")
        }
        //let midCeil = midFloor + 100
        
        
        let homeScoringTotal = homeAtk + homeAdv + awayDef + awayGlk
        let awayScoringTotal = awayAtk + homeDef + homeGlk + homeAdv

        // Once chance is created, this is the chance the team will convert chance into a goal
        // This is usally pretty low as its just your ATK vs oppponent's DEF and GK (Maybe include half midfield rating?)
        var homeScoringPerc = (homeAtk + homeAdv) / homeScoringTotal
        let awayScoringPerc = awayAtk / awayScoringTotal
        
        var homeGoalMidPoint = Int(homeScoringPerc * 1000) - 100
        var awayGoalMidPoint = Int(awayScoringPerc * 1000) - 100
        
        if(homeGoalMidPoint < 100){
            homeGoalMidPoint = 100
        }
        
        if(awayGoalMidPoint < 100){
            awayGoalMidPoint = 100
        }
        
        
        for(var i = 0; i < 90; i = i + 5){
            
            var scoringChance = Int(arc4random_uniform(1000))
            
            if(scoringChance < midFloor){
                //Home chance
                //                println("Home chance!")
                var goalChance = Int(arc4random_uniform(1000))
                if(goalChance < homeGoalMidPoint){
                    //Goal for home team!
                    homeGoals++
                }
                
            }else if(scoringChance > midCeil){
                //Away chance
                //                println("away chance!")
                var goalChance = Int(arc4random_uniform(1000))
                if(goalChance < awayGoalMidPoint){
                    //Goal for away team!
                    awayGoals++
                }
                
            }else{
                //                println("No chance!")
            }
        }
        
        
    }
    
    private func getPositionRating(players : [Player])->Float{
        var rating : Float = 0.0
        for(var i = 0; i < players.count; i++){
            rating += players[i].getRating()
        }
        return rating / (Float(players.count))
    }
    
    private func updateTeamsFromResult(){
        let realm = try! Realm()
        let homeTeam = realm.objects(LeagueTableData.self).filter("teamId == '" + homeTeamId! + "'").first
        let awayTeam = realm.objects(LeagueTableData.self).filter("teamId == '" + awayTeamId! + "'").first

        if(fixtureResult == FixtureResult.HOME_WIN){
            homeTeam?.addWin()
            awayTeam?.addLoss()
        }else if(fixtureResult == FixtureResult.AWAY_WIN){
            awayTeam?.addWin()
            homeTeam?.addLoss()
        }else{
            homeTeam?.addDraw()
            awayTeam?.addDraw()
        }
        
        homeTeam?.addGoalsFor(homeGoals)
        homeTeam?.addGoalsAgainst(awayGoals)
        
        awayTeam?.addGoalsFor(awayGoals)
        awayTeam?.addGoalsAgainst(homeGoals)
    }
    
    
    /* * * * * * * * * * * * * * */
    /*     Display Functions     */
    /* * * * * * * * * * * * * * */
    
    func printFixture(){
        var fixtureId = self.fixtureId

        var homeString = "Home: " + self.homeTeamDisplayName!
        var awayString = "Away: " + self.awayTeamDisplayName!
        
        if(homeGoals != -1){
            homeString = homeString  + " - " + String(homeGoals)
            awayString = awayString  + " - " + String(awayGoals)
            
            print(homeString)
            print(awayString)

            print("")
            
        }else{
            print(String(gameWeek)  + " - " + homeString + " v. " + awayString)
        }
        
    }
    
}



