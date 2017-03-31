//
//  LeagueManager.swift
//  JustABitOfFooty
//
//  Created by Kevin Zakszewski on 2/28/16.
//  Copyright (c) 2016 Kevin Zakszewski. All rights reserved.
//

import Foundation
import RealmSwift

class LeagueManager :NSObject {
    var mLeagues : [League] = []

    override init(){
        super.init()
        let realm = try! Realm()
        let leagues = realm.objects(League.self)

        for existingLeague in leagues{
            mLeagues.append(existingLeague)
            existingLeague.displayTable()
        }
    }


    func addLeague(league : League){
        mLeagues.append(league)
    }

    func displayLeagueTables(){
        for(var i = 0; i < mLeagues.count; i++){
            mLeagues[i].displayTable()
        }
    }
    
    func displayLeagueTableByLeagueId(leagueId : Int){
        if(mLeagues.count > leagueId && (!(leagueId < 0))){
            mLeagues[leagueId].displayTable()
        }
    }

    
    func resetSeason(){
        for(var i = 0; i < mLeagues.count; i++){
            mLeagues[i].resetSeason()
        }
    }
    
    func playNextGameWeek(){
        
        for(var i = 0; i < mLeagues.count; i++){
            if(!mLeagues[i].isSeasonComplete()){
                mLeagues[i].playNextFixture(true)
            }
        }
        
        // TODO: HANDLE WHEN SEASON IS OVER
        var allLeaguesComplete = true;
        for(var i = 0; i < mLeagues.count; i++){
            if(!mLeagues[i].isSeasonComplete()){
                allLeaguesComplete = false;
                break
            }
        }
        
        if(allLeaguesComplete){
            handleSeasonComplete()
        }
        
        
    }
    
    
    func playSeason(){
        var allLeaguesComplete : Bool = false;
        while(!allLeaguesComplete){
            for(var i = 0; i < mLeagues.count; i++){
                mLeagues[i].playNextFixture()
            }
            
            allLeaguesComplete = true;
            for(var i = 0; i < mLeagues.count; i++){
                if(!mLeagues[i].isSeasonComplete()){
                    allLeaguesComplete = false;
                    break
                }
            }
        }
        
        handleSeasonComplete()
    }
    
    private func handleSeasonComplete(){
        for(var i = 0; i < mLeagues.count; i++){
            mLeagues[i].displayLeaders()
        }
        
        handleLeagueWinner()
        handlePromotionAndRelegation()
        resetSeason()
        handleTransferBusiness();
    }
    
    
    func handleLeagueWinner(){
        for(var i = 0; i < mLeagues.count; i++){
            mLeagues[i].handleLeagueWinner()
        }
    }
    
    func handlePromotionAndRelegation(){
        for(var i = 0; i < mLeagues.count; i++){
            mLeagues[i].handlePromotionAndRelegation()
        }
    }
    
    func handleTransferBusiness(){
        for(var i = 0; i < mLeagues.count; i++){
            mLeagues[i].handleTransferBusiness()
        }
    }
    
    func displayStats(){
        for(var i = 0; i < mLeagues.count; i++){
            mLeagues[i].displayTeamStats()
        }
    }
    
    
}