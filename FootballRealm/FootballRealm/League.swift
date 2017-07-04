//
//  League.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 11/20/16.
//  Copyright © 2016 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class League: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var name: String = ""
    dynamic var league_id: String = ""
    dynamic var league_table: LeagueTable?

    dynamic var league_above: League?
    dynamic var league_below: League?
    dynamic var num_promoted: Int = 0
    dynamic var num_relegated: Int = 0
    dynamic var maxTransfer = 10
    dynamic var minTransfer = 10


    dynamic var mFixtureManager : FixtureManager?
    
    let mTeams = List<Team>()
    let mNewTeams = List<Team>()

    
    convenience init(name : String, id : String, teams : List<Team>, promoted : Int, relegated : Int, maxTransferAmt : Int, minTransferAmt : Int) {
        self.init()
        self.name = name
        self.league_id = id
        let realm = try! Realm()
        
        for  team in teams{
            try! realm.write {
                team.league_id = id
                realm.add(team, update: true)
            }
            self.mTeams.append(team)
        }
        
        self.num_promoted = promoted
        self.num_relegated = relegated
        self.maxTransfer = maxTransferAmt
        self.minTransfer = minTransferAmt
        
        league_table = LeagueTable(teams: teams, league: name)
        league_table!.sortTable();
//        displayTable()

        
        mFixtureManager = FixtureManager(teams: teams, id: id)
        try! realm.write {
            realm.add(mFixtureManager!)
        }
    }
    
    func setLeagueAbove(abvLeague : League){
        self.league_above = abvLeague
    }
    
    func setLeagueBelow(blwLeague : League){
        self.league_below = blwLeague
    }
    
    
    func playNextFixture(printFixtures : Bool = false){
        if(!isSeasonComplete()){
            mFixtureManager?.playNextFixtureWeek(printFixtures)
        }
        
    }

    
    func promoteClubs(){
        var teamsToPromote : [Team] = []
        var sortedTable = league_table!.getSortedTable()
        let numOfTeamsPromoted = Int(num_promoted)
        
        
        if((league_above != nil) && numOfTeamsPromoted > 0){
            for(var i = 0; i < numOfTeamsPromoted; i++){
                teamsToPromote.append(sortedTable[i])
                removeTeamById(sortedTable[i].getId())
            }
            print("Teams promoted from " + name)
            for(var i = 0; i < teamsToPromote.count; i++){
                teamsToPromote[i].addPromotion()
                teamsToPromote[i].setPromotedBoolean()
                print(teamsToPromote[i].getName())
            }
            print()
            league_above!.acceptNewTeams(teamsToPromote)
        }
        
        
    }
    
    
    func relegateClubs(){
        var teamsToRelegate : [Team] = []
        var sortedTable = league_table!.getSortedTable()
        let numOfTeamsRelegated = Int(num_relegated)
        
        if(league_below != nil && numOfTeamsRelegated > 0){
            
            for(var i = numOfTeamsRelegated; i > 0; i--){
                teamsToRelegate.append(sortedTable[(sortedTable.count) - i])
                removeTeamById(sortedTable[(sortedTable.count) - i].getId())
            }
            
            // Display relegation teams and updates stats
            print("Teams releated from " + name)
            for(var i = 0; i < teamsToRelegate.count; i++){
                teamsToRelegate[i].addRelegation()
                teamsToRelegate[i].setRelegatedBoolean()

                print(teamsToRelegate[i].getName())
            }
            print()
            
            
            league_below!.acceptNewTeams(teamsToRelegate)
        }
        
    }
    
    
    func acceptNewTeams(newTeams : [Team]){
        let realm = try! Realm()
        try! realm.write(){
            mNewTeams.removeAll()
            
            for(var i = 0; i < newTeams.count; i++){
                mNewTeams.append(newTeams[i])
            }        
        }
    }


    
    func removeTeamById(teamId : String){
        let realm = try! Realm()
        for(var i = 0; i < mTeams.count; i++){
            if(mTeams[i].getId() == teamId){
                try! realm.write(){
                    mTeams.removeAtIndex(i)
                }
                break
            }
        }
    }
    
    func handleLeagueWinner(){
        let team = league_table!.getSortedTable()[0]
        let realm = try! Realm()

        team.addLeagueTitle()
    }
    
    
    func handlePromotionAndRelegation(){
        promoteClubs()
        relegateClubs()
    }
    
    func updateTeams(){
        let realm = try! Realm()
        try! realm.write(){
            
            // Added promoted and relegated teams
            for(var i = 0; i < mNewTeams.count; i++){
                mTeams.append(mNewTeams[i])
            }
            
            
            mNewTeams.removeAll()
        }
        
        mFixtureManager!.updateTeams(mTeams)
        mFixtureManager!.resetFixtures()
        
        league_table!.updateTeams(mTeams)
    }
    
    
    func resetSeason(){
        for(var i = 0; i < mTeams.count; i++){
            mTeams[i].resetTeamSeason()
        }
    }

    func isSeasonComplete()->Bool{
        var seasonCompelte = mFixtureManager?.isSeasonComplete()
        return seasonCompelte!
    }
    
    func handleTransferBusiness(){
        for(var i = 0; i < mTeams.count; i++){
            mTeams[i].transferBusiness(maxTransfer, maxSubtraction: minTransfer)
        }
    }
    
    //   * * * * * DISPLAY FUNCTIONS * * * * *
    
    func displayTeamPlayers(){
        for(var i = 0; i < mTeams.count; i++){
            mTeams[i].displayPlayers()
            print()
        }
    }
    
    func displayTeamRatings(){
        for(var i = 0; i < mTeams.count; i++){
            mTeams[i].displayRatings()
            print()
        }
    }

    func displayTeamStats(){
        for(var i = 0; i < mTeams.count; i++){
            mTeams[i].displayStats()
            print()
        }
    }
    
    func displayTable(){
        print("----- " + name + " Table -----")
        league_table!.printTable()
    }
    
    func displayLeaders(){
        if(mFixtureManager!.isSeasonComplete()){
            print("Winners ")
        }
        
        print(league_table!.getLeagueLeaders())
        displayTable()
    }

}

