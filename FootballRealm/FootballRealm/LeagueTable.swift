//
//  LeagueTable.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 11/23/16.
//  Copyright © 2016 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class LeagueTable: Object {
    var mOrderedTeamData = List<LeagueTableData>()
    dynamic var leagueId = ""
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }

    convenience init(teams : List<Team>, league: String) {
        self.init()
        leagueId = league
        initiateLeagueTableData(teams)
    }
    
    func initiateLeagueTableData(teams : List<Team>){
        let realm = try! Realm()

        for team in teams{
            let leagueTableDataEntry = LeagueTableData(id: team.getId(), league: leagueId)

            try! realm.write {
                realm.add(leagueTableDataEntry, update: true)
            }

          //  mOrderedTeamData.append(leagueTableDataEntry)
        }
    }
    

    func sortTable(){
        // This will Sort the table
//        let realm = try! Realm()
//        let teamData = realm.objects(LeagueTableData.self).filter("leagueId == '" + leagueId + "'").sorted("points", ascending: false)
    }
    
    func printTable(){
        let realm = try! Realm()
        let teamData = realm.objects(LeagueTableData.self).filter("leagueId == '" + leagueId + "'").sorted("points", ascending: false)
        
        for(var i = 0; i < teamData.count; i++){
            print(teamData[i].getTeamName())
            print(teamData[i].getPoints())
        }
        
        print()
    }
    
    func getLeagueLeaders()->String{
        let realm = try! Realm()
        let teamData = realm.objects(LeagueTableData.self).filter("leagueId == '" + leagueId + "'").sorted("points", ascending: false).first

        return (teamData?.getTeamName())!
    }

    
    func getLeagueLeadersId()->String{
        let realm = try! Realm()
        let teamData = realm.objects(LeagueTableData.self).filter("leagueId == '" + leagueId + "'").sorted("points", ascending: false).first
        
        return (teamData?.getTeamId())!
    }

    
    func updateTeams(teams : List<Team>){
        initiateLeagueTableData(teams)
    }
    
    
    func getSortedTable()->List<Team>{
        sortTable()
        let realm = try! Realm()
        let teamData = realm.objects(LeagueTableData.self).filter("leagueId == '" + leagueId + "'").sorted("points", ascending: false)

        let orderedTeams = List<Team>()
        for(var i = 0; i < teamData.count; i++){
            let team = realm.objects(Team.self).filter("nid == '" + teamData[i].getTeamId() + "'").first
            orderedTeams.append(team!)

        }

        return orderedTeams
    }
    
}
