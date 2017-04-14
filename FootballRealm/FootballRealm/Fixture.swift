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

//    dynamic var homeTeam : Team?
//    dynamic var awayTeam : Team?
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
        self.fixtureId = home.getId() + "_" + away.getId() + "_" + id + "_" + String(week)
    }
    
    func playMatch(printFixtr : Bool = false){
        let realm = try! Realm()
        
        try! realm.write {
        homeGoals = 0
        awayGoals = 0
        
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
    
    func printFixture(){
        var homeString = "Home: " + homeTeamId!
        var awayString = "Away: " + awayTeamId!

        if(homeGoals != -1){
            homeString = homeString  + " - " + String(homeGoals)
            awayString = awayString  + " - " + String(awayGoals)

            print(homeString)
            print(awayString)
            print("")

        }else{
            print(homeString + " v. " + awayString)
        }
        
    }
    
    
    
//    func getHomeTeam()-> Team{ return homeTeam! }
//    func getAwayTeam()-> Team{ return awayTeam! }
//    func getWinningTeam() -> Team { return winningTeam! }
//    func getLosingTeam() -> Team { return losingTeam! }
    
    func getResult()->FixtureResult{ return fixtureResult! }
    
    func getHomeScore()->Int { return homeGoals }
    func getAwayScore()->Int { return awayGoals }
    
    
    private func playFixture(){
        let realm = try! Realm()
        let homeTeam = realm.objects(Team.self).filter("nid == '" + homeTeamId! + "'").first
        let awayTeam = realm.objects(Team.self).filter("nid == '" + awayTeamId! + "'").first
        

        // Gets the rating fo the teams for calculation
        var homeOvr = homeTeam?.getOverallRating()
        var awayOvr = awayTeam?.getOverallRating()
        
        var homeMid = homeTeam?.getMidfieldRating()
        var awayMid = awayTeam?.getMidfieldRating()
        
        var homeAtk = homeTeam?.getAttackRating()
        var awayAtk = awayTeam?.getAttackRating()
        
        var homeDef = homeTeam?.getDefenseRating()
        var awayDef = awayTeam?.getDefenseRating()
        
        var homeGlk = homeTeam?.getGoalkeeperRating()
        var awayGlk = awayTeam?.getGoalkeeperRating()
        
        
        // Base for formula on how chancces are created
        var homeChanceBase = homeMid! + homeAtk! + awayMid! + awayDef!
        var awayChanceBase = awayMid! + awayAtk! + homeMid! + homeDef!
        
        // Gives rating of chance creation
        var homeChanceTotal = ((homeAtk! + homeMid!) / homeChanceBase)  * 100
        var awayChanceTotal = ((awayAtk! + awayMid!) / awayChanceBase)  * 100
        
        //Percentage/chance the teams will create a scoring opportunity
        //The - 0.075 creates a 15% chance neither team will create a scoring opportunity
        var homeChancePercent = (homeChanceTotal) / (homeChanceTotal + awayChanceTotal) - 0.075
        var awayChancePercent = (awayChanceTotal) / (homeChanceTotal + awayChanceTotal) - 0.075
        
        //Values used when random number is generated for scoring opporunity
        //Between midfloor and midCeil represents the 15% chance that no one makes a scoring opportunity
        var midFloor = Int(homeChancePercent * 1000)
        var midCeil = midFloor + 100
        
        
        
        
        var homeScoringTotal = homeAtk! + awayDef! + awayGlk!
        var awayScoringTotal = awayAtk! + homeDef! + homeGlk!
        
        var homeScoringPerc = homeAtk! / homeScoringTotal
        var awayScoringPerc = awayAtk! / awayScoringTotal
        
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
                    //Goal for home team!
                    awayGoals++
                }
                
            }else{
                //                println("No chance!")
            }
        }
        
        
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
    
}



