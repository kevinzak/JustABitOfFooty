//
//  ViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 11/20/16.
//  Copyright © 2016 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    var gkPerTeam = 3
    var defPerTeam = 8
    var midPerTeam = 8
    var atkPerTeam = 5
    
    var teamList = List<Team>()
    var teamListLeagueTwo = List<Team>()
    
    var mLeagueManager : LeagueManager!
    let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    var teamNameList : [String] = [
        "Arsenal",
        "Aston Villa",
        "Bournemouth",
        "Chelsea",
        "Crystal Palace",
        "Everton",
        "Leicester",
        "Liverpool",
        "Man City",
        "Man United",
        "Newcastle",
        "Norwich",
        "Southampton",
        "Stoke",
        "Sunderland",
        "Swansea",
        "Spurs",
        "Watford",
        "West Brom",
        "West Ham"
    ]
    
    var teamNameList_LeagueTwo : [String] = [
        "Hull City",
        "Brighton",
        "Middlesbrough",
        "Derby County",
        "Burnley",
        "Birmingham",
        "Reading",
        "Sheff Wednesday",
        "Cardif City",
        "Ipswich Town",
        "Brentford",
        "Fulham",
        "Blackburn",
        "Wolves",
        "QPR",
        "Leeds United",
        "Nottingham Forest",
        "Bristol City",
        "Charlton",
        "Preston",
        "Huddersfield",
        "MK Dons",
        "Rotherham",
        "Bolton"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        generateLocations()
        generateTeams()
        generateLeagues()
        // Creates a new League Manager each time. League Manager loads the leagues 
        // from Realm in its constructor and treats them as local instances essentailly
        mLeagueManager = LeagueManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Industrial (yards) (road) (court), affluent (bridge?) (court) (way) (street), residential (road) (cottage) (lane) (way)  (street), swamplands (moor), countryside (grounds) (meadow) (grove), forrested area, park area (park) (grove)
    
    func generateLocations(){
        let realm = try! Realm()
        let locations = realm.objects(LocationModel.self)
        if(locations.count == 0){
            let location_1 = LocationModel(name: "Hampton Yard",type: "Industrial",area: 10.0, pitch: 30.0,access: 20.0)
            let location_2 = LocationModel(name: "Sutton Road",type: "Industrial",area: 15.0, pitch: 20.0,access: 15.0)
            let location_3 = LocationModel(name: "James Court",type: "Affluent",area: 40.0, pitch: 30.0, access: 20.0)
            let location_4 = LocationModel(name: "Smithwick Lane",type: "Residential",area: 15.0, pitch: 15.0,access: 10.0)
            let location_5 = LocationModel(name: "Ashburton",type: "Residential",area: 30.0, pitch: 20.0,access: 15.0)
            let location_6 = LocationModel(name: "Tulip Court Road",type: "Residential",area: 25.0, pitch: 30.0,access: 20.0)
            let location_7 = LocationModel(name: "Bernshire Moor",type: "Countryside",area: 15.0, pitch: 15.0,access: 10.0)
            let location_8 = LocationModel(name: "Stafferd Ground",type: "Countryside",area: 20.0, pitch: 20.0,access: 15.0)
            let location_9 = LocationModel(name: "Sheffton Park",type: "Park",area: 25.0, pitch: 30.0,access: 25.0)
            let location_10 = LocationModel(name: "Windtree Grove",type: "Park",area: 20.0, pitch: 40.0, access: 15.0)
        
            try! realm.write {
                realm.add(location_1)
                realm.add(location_2)
                realm.add(location_3)
                realm.add(location_4)
                realm.add(location_5)
                realm.add(location_6)
                realm.add(location_7)
                realm.add(location_8)
                realm.add(location_9)
                realm.add(location_10)
            }
        }else{
            print("already have locations")
        }

    }

    func generateTeams(){
        let realm = try! Realm()
        let teams = realm.objects(Team.self)
        if(teams.count == 0){
            
        // Generates Arsenal as perfect
        teamList.append(Team(name: teamNameList[0], attack: 100, midfield: 100, defense: 100, goalkeeper: 100))
        // Generate rest of Premier League clubs
        for(var i = 1; i < teamNameList.count; i++){
            let atk = Float(arc4random_uniform(50) + 50)
            let mid = Float(arc4random_uniform(50) + 50)
            let def = Float(arc4random_uniform(50) + 50)
            let glk = Float(arc4random_uniform(50) + 50)
            let newTeam = Team(name: teamNameList[i], attack: atk, midfield: mid, defense: def, goalkeeper: glk)
            teamList.append(newTeam)
            
            print(teamList[i].getName())
            print(teamList[i].getAttackRating())
            print(teamList[i].getMidfieldRating())
            print(teamList[i].getDefenseRating())
            print(teamList[i].getGoalkeeperRating())

            try! realm.write {
                realm.add(newTeam)
            }

        }
        
        // Generate second teir (Championship)
        for(var i = 0; i < teamNameList_LeagueTwo.count; i++){
            let atk = Float(arc4random_uniform(50) + 25)
            let mid = Float(arc4random_uniform(50) + 25)
            let def = Float(arc4random_uniform(50) + 25)
            let glk = Float(arc4random_uniform(50) + 25)
            
            let newTeam = Team(name: teamNameList_LeagueTwo[i], attack: atk, midfield: mid, defense: def, goalkeeper: glk)

            teamListLeagueTwo.append(newTeam)
            try! realm.write {
                realm.add(newTeam)
            }

        }
        }else{            
            print("already have teams")
        }

    }
    
    
    func generateLeagues(){
        let realm = try! Realm()

        let leagues = realm.objects(League.self)
        if(leagues.count == 0){
            var premierLeague : League = League(name: "Premier League", id: "Eng_0", teams: teamList, promoted: 0, relegated: 3, maxTransferAmt : 10, minTransferAmt : 10)
            var championship : League = League(name: "Championship", id: "Eng_1", teams: teamListLeagueTwo, promoted: 3, relegated: 0, maxTransferAmt : 5, minTransferAmt : 5)
            
            premierLeague.setLeagueBelow(championship)
            championship.setLeagueAbove(premierLeague)
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(premierLeague)
                realm.add(championship)
            }
            
        }else{
            for(var i = 0; i < leagues.count; i++){
                print(leagues[i].name)
                print(leagues[i].mTeams.count)
                if(leagues[i].league_above != nil){
                    print(leagues[i].league_above?.name)
                }
                if(leagues[i].league_below != nil){
                    print(leagues[i].league_below?.name)
                }
                
                for(var k = 0; k < leagues[i].mTeams.count; k++){
                    print(leagues[i].mTeams[k].name)
                }
            }
            
            let fixtures = realm.objects(Fixture.self)
            print(fixtures.count)
            let fixtureManagers = realm.objects(FixtureManager.self)
            print(fixtureManagers.count)
            for(var i = 0; i < fixtureManagers.count; i++){
                print(fixtureManagers[i].leagueId)
            }
            
            print("Already have leagues")
        }

    }
    
    func resetSeason(){
        mLeagueManager?.resetSeason()
    }
    
    @IBAction func playGameWeek(){
        mLeagueManager?.playNextGameWeek();
    }
    
    @IBAction func playSeason(){
        mLeagueManager?.playSeason()
    }
    
    @IBAction func displayTable(){
        mLeagueManager?.displayLeagueTables()
    }
    
    @IBAction func displayTeamStats(){
        mLeagueManager?.displayStats()
    }
    
    @IBAction func displayTeamRatings(){
        mLeagueManager?.displayTeamRatings()
    }

    @IBAction func displayTeamPlayers(){
        mLeagueManager?.displayTeamPlayers()
    }

    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }

    

}

