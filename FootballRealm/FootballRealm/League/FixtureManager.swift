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
        makeFixtures()
    }
    
    
    func getCurrentGameWeek()->Int{
        return currentWeek
    }
    
    func updateTeams(teams : List<Team>){
        let realm = try! Realm()
        print("Updating teams for " + leagueId)
        for team in teams{
            print(team.getName())
        }
        print("")

        
        try! realm.write(){
            
            mTeams.removeAll()
            for team in teams{
                mTeams.append(team)
            }
        }
//        makeFixtures();
    }
    
    
    func isSeasonComplete() -> Bool{
        if(currentWeek == seasonLength){
            return true
        }else{
            return false
        }
    }

    
    func makeFixtures(){
        let realm = try! Realm()
        try! realm.write {
            seasonLength = ((mTeams.count * 2 ) - 2)
        }
        
        var tempTeamList = List<Team>();
        
        for(var j = 0; j < mTeams.count; j++){
            tempTeamList.append(mTeams[j])
        }
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
                
                var isUserMatch = false
                if(homeTeam?.getId() == "user" || awayTeam?.getId() == "user"){
                    isUserMatch = true
                }
            
                
                var fixture = Fixture(home: homeTeam!, away: awayTeam!, id : leagueId, week : i, userMatch: isUserMatch)

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
        print (leagueId + " Week " + String(week))
        let realm = try! Realm()

        var weeklyFixtures = realm.objects(Fixture.self).filter("leagueId contains '" + leagueId + "' AND gameWeek == " + String(week))

        for(var i = 0; i < weeklyFixtures.count; i++){
            if(weeklyFixtures[i].isMatchPlayed() == false){
                weeklyFixtures[i].playMatch(printFixtures)
            }else{
                print("Match played!")
            }
        }
        
        try! realm.write {
            realm.add(weeklyFixtures, update: true)
        }
        
        if(printFixtures){
            print()
        }
    }

    func playFixtureById(id : String, printFixtures : Bool = false){
        let realm = try! Realm()
        
        var fixture = realm.objects(Fixture.self).filter("leagueId contains '" + leagueId + "' AND fixtureId contains '" + id + "'")
        
        if(fixture.count > 0){
            if(fixture[0].isMatchPlayed() == false){
                fixture[0].playMatch(printFixtures)
            }else{
                print("Match played!")
            }
        }

        try! realm.write {
            realm.add(fixture, update: true)
        }
        
        if(printFixtures){
            print()
        }
    }

    func resetFixtures(){
        let realm = try! Realm()
        var leagueFixtures = realm.objects(Fixture.self).filter("leagueId contains '" + leagueId + "'")
        
        try! realm.write {
            currentWeek = 0
            realm.delete(leagueFixtures)
        }
        makeFixtures()
    }
    /* * * * * * * * * * * * * * */
    /*      Getters/Setters      */
    /* * * * * * * * * * * * * * */
    
    func getGameWeek()->Int{
        return self.currentWeek
    }
    func getLeagueId()->String{
        return self.leagueId
    }
    func getSeasonLength()->Int{
        return self.seasonLength
    }
    
    
    /* * * * * * * * * * * * * * */
    /*     Display Functions     */
    /* * * * * * * * * * * * * * */
    
    func printFixturesByTeam(id : String){
        let realm = try! Realm()
        var teamHomeFixtures = realm.objects(Fixture.self).filter("homeTeamId contains '" + id + "'")
        var teamAwayFixtures = realm.objects(Fixture.self).filter("awayTeamId contains '" + id + "'")
        
        print("* " + id + " Fixtures *")
        print("HOME FIXTURES: " + String(teamAwayFixtures.count))
        for fixture in teamHomeFixtures{
            fixture.printFixture()
        }
        print("AWAY FIXTURES: " + String(teamAwayFixtures.count))
        for fixture in teamAwayFixtures{
            fixture.printFixture()
        }
    }
    
}
