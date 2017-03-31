//
//  FixtureManager.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 3/14/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class FixtureManager: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }

    dynamic var currentWeek : Int = 0
    dynamic var seasonLength : Int = 0

    dynamic var leagueId : String = ""
//    var mFixtures : [Int: [Fixture]] = [:]

    let mTeams = List<Team>()
//    let mFixtures = List<Fixture>()
    
    convenience init(teams: List<Team>, id : String){
        self.init()
        leagueId = id
        updateTeams(teams)
    }
    
    
    func getCurrentGameWeek()->Int{
        return currentWeek
    }
    
    func updateTeams(teams : List<Team>){
        //        mTeams = teams;
        mTeams.removeAll()
        for team in teams{
            mTeams.append(team)
        }
        makeFixtures();
    }
    
    
    func isSeasonComplete() -> Bool{
        if(currentWeek == seasonLength){
            return true
        }else{
            return false
        }
    }

    
    func makeFixtures(){
        seasonLength = ((mTeams.count * 2 ) - 2)
        var tempTeamList = mTeams;
        var tOneIsHome = true;
        
        
        //Iterate through weeks first half
        //i represenents the week
        for(var i = 0; i < ((mTeams.count * 2 ) - 2); i++){
            var weeklyFixtures : [Fixture] = []
            
            //resplit teams
            var mid = tempTeamList.count / 2
            var tOne : [Team] = []
            var tTwo : [Team] = []
            
            //Init divisions
            for(var i = 0; i < mTeams.count; i++){
                if(i < mid){
                    tOne.append(tempTeamList[i])
                }else{
                    tTwo.append(tempTeamList[i])
                }
            }
            
            tTwo = tTwo.reverse();
            
            //ZIP FUNC
            for(var j = 0; j < tOne.count; j++){
                //make fixture between tOne[j] and tTwo[j]
                var homeTeam : Team?
                var awayTeam : Team?
                
                if(tOneIsHome){
                    homeTeam = tOne[j]
                    awayTeam = tTwo[j]
                }else{
                    homeTeam = tTwo[j]
                    awayTeam = tOne[j]
                    
                }
                
                var fixture = Fixture(home: homeTeam!, away: awayTeam!, id : leagueId, week : i)
                let realm = try! Realm()
                try! realm.write {
                    realm.add(fixture)
                }
                
                weeklyFixtures.append(fixture);
                
            }
            
            //Add weekly fixture list to list
//            mFixtures[i] = weeklyFixtures
//            mFixtures.append(weeklyFixtures)
            
            //Switch home/away
            tOneIsHome = !tOneIsHome
            
            //increment "chair position by advancing tempList
            tempTeamList.insert(tempTeamList.removeLast(), atIndex: 1)
            
            //            printFixturesByWeek(i)
            
        }
    }
    
    func playNextFixtureWeek(printFixtures : Bool = false){
        playFixturesByWeek(currentWeek, printFixtures: printFixtures);

        let realm = try! Realm()
        try! realm.write {
            currentWeek++;
        }
    }
    
    func playFixturesByWeek(week : Int, printFixtures : Bool = false){
        let realm = try! Realm()

        var weeklyFixtures = realm.objects(Fixture.self).filter("leagueId contains '" + leagueId + "' AND gameWeek == " + String(week))

        for(var i = 0; i < weeklyFixtures.count; i++){
            weeklyFixtures[i].playMatch(printFixtures)
        }
        
        try! realm.write {
            realm.add(weeklyFixtures, update: true)
        }
        
        if(printFixtures){
            print()
        }
        
        
    }

    func resetFixtures(){
        let realm = try! Realm()
        currentWeek = 0
        var leagueFixtures = realm.objects(Fixture.self).filter("leagueId contains '" + leagueId + "'")
        try! realm.write {
            realm.delete(leagueFixtures)
        }

        makeFixtures()
    }

    
}
