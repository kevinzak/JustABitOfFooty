//
//  LeagueTableData.swift
//  JustABitOfFooty
//
//  Created by Kevin Zakszewski on 3/27/16.
//  Copyright (c) 2016 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class LeagueTableData: Object
{
    dynamic private var wins  = 0
    dynamic private var draws = 0
    dynamic private var loses = 0
    dynamic private var goals_against = 0
    dynamic private var goals_for = 0
    dynamic private var matches_played = 0
    dynamic private var points = 0
    
    //    dynamic var league_table: LeagueTable!
    //    dynamic var team: Team!
    dynamic var teamId = "";
    dynamic var teamName = "";
    dynamic var leagueId = "";

    override static func primaryKey() -> String? {
        return "teamId"
    }
    
    convenience init(id: String, league: String) {
        self.init()
        self.teamId = id
        self.leagueId = league

        let realm = try! Realm()
        let teams = realm.objects(Team.self).filter("nid == '" + teamId + "'")
        if(teams.count != 0){
            teamName = teams[0].getName()
        }else{
            teamName = teamId
        }
        
        self.matches_played = 0
        self.wins = 0
        self.loses = 0
        self.draws = 0
        self.goals_for = 0
        self.goals_against = 0
        self.points = 0
    }
    
    
    func setMatchesPlayed(mp : Int){ self.matches_played = mp }
    func setTeamWins(wins : Int){ self.wins = wins }
    func setTeamLoses(loses : Int){ self.wins = loses }
    func setTeamDraws(draws : Int){ self.draws = draws }
    func setTeamGoalsFor(gf : Int){ self.goals_for = gf }
    func setTeamGoalsAgainst(ga : Int){ self.goals_against = ga }
    func setTeamPoints(pts : Int){ self.points = pts }
    
    func getTeamName()->String{ return self.teamName }
    func getTeamId()->String{ return self.teamId }
    //    func getTeam()->Team{ return team }
    func getMatchesPlayed()->Int{ return Int(self.matches_played); }
    func getWins()->Int{ return Int(self.wins); }
    func getLoses()->Int{ return Int(loses); }
    func getDraws()->Int{ return Int(draws); }
    func getGoalsFor()->Int{ return Int(goals_for); }
    func getGoalsAgainst()->Int{ return Int(goals_against); }
    func getPoints()->Int{ return Int(points); }

    func addMatchPlayed(){ self.matches_played = Int(matches_played) + 1 }
    func addGoalsFor(goals : Int){ self.goals_for = Int(goals_for) + goals }
    func addGoalsAgainst(goals : Int){ goals_against = Int(goals_against) + goals }
    func addPoints(pts : Int){ points = Int(points) + pts }

    func addLoss(){
        addMatchPlayed()
        self.loses = Int(loses) + 1
    }

    func addWin(){
        addMatchPlayed()
        self.wins = Int(wins) + 1
        addPoints(3)
    }

    func addDraw(){
        addMatchPlayed()
        self.draws = Int(draws) + 1
        addPoints(1)
    }

    func resetTeamSeason(){
        setMatchesPlayed(0)
        setTeamWins(0)
        setTeamLoses(0)
        setTeamDraws(0)
        setTeamGoalsFor(0)
        setTeamGoalsAgainst(0)
        setTeamPoints(0)
    }
    
    
    
}


