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
    
    var teamList = List<Team>()
    var teamListLeagueTwo = List<Team>()
    
    var mLeagueManager : LeagueManager!

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
        generateTeams()
        generateLeagues()
        mLeagueManager = LeagueManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            print(teamListLeagueTwo[i].getName())
            print(teamListLeagueTwo[i].getAttackRating())
            print(teamListLeagueTwo[i].getMidfieldRating())
            print(teamListLeagueTwo[i].getDefenseRating())
            print(teamListLeagueTwo[i].getGoalkeeperRating())
            
            try! realm.write {
                realm.add(newTeam)
            }

        }
        }else{
//            let eng_0_Teams = realm.objects(Team.self).filter("league_id contains 'Eng_0'")
 //           let eng_1_Teams = realm.objects(Team.self).filter("league_id contains 'Eng_1'")

//            print(eng_0_Teams.count)
 //           print(eng_1_Teams.count)
            
            print("already have teams")
        }

    }
    
    func generateLeagues(){
        let realm = try! Realm()

        let leagues = realm.objects(League.self)
        if(leagues.count == 0){
            var premierLeague : League = League(name: "Premier League", id: "Eng_0", teams: teamList, promoted: 0, relegated: 3)
            var championship : League = League(name: "Championship", id: "Eng_1", teams: teamListLeagueTwo, promoted: 3, relegated: 0)
            
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
    


}

