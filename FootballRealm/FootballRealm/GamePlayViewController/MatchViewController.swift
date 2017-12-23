//
//  MatchViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 12/22/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import RealmSwift
import UIKit

class MatchViewController: UIViewController {

    @IBOutlet weak var mWeekLbl: UILabel!
    @IBOutlet weak var mAwayTeamLbl: UILabel!
    @IBOutlet weak var mHomeTeamLbl: UILabel!
    @IBOutlet weak var mHomeGoalsLbl: UILabel!
    @IBOutlet weak var mAwayGoalsLbl: UILabel!
    
    var fixtureId : String = ""
    var leagueId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        let userTeam = realm.objects(Team.self).filter("nid == 'user'")
        leagueId = userTeam[0].getLeagueId()
        var fixtureManager = realm.objects(FixtureManager.self).filter("leagueId contains '" + leagueId + "'")
        if(fixtureManager.count == 1){
            var leagueFilter = "leagueId contains '" + leagueId
            var fixtureFilter = "' AND fixtureId contains '" + userTeam[0].getId() + "' AND gameWeek == " + String(fixtureManager[0].getGameWeek())
            
            var fixture = realm.objects(Fixture.self).filter(leagueFilter + fixtureFilter)
            if(fixture.count == 1){
                fixtureId = fixture[0].getFixtureId()
                layoutView(fixture[0])
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func layoutView(fixtureModel : Fixture){
        mWeekLbl.text = String(fixtureModel.getGameWeek())
        mAwayTeamLbl.text = fixtureModel.getAwayTeamDisplayName()
        mHomeTeamLbl.text = fixtureModel.getHomeTeamDisplayName()
        mAwayGoalsLbl.text = String(fixtureModel.getAwayScore())
        mHomeGoalsLbl.text = String(fixtureModel.getHomeScore())
    }
    
    @IBAction func playMatch(sender: AnyObject) {
        let realm = try! Realm()
        let userTeam = realm.objects(Team.self).filter("nid == 'user'")
        
        var fixtureManager = realm.objects(FixtureManager.self).filter("leagueId contains '" + leagueId + "'")
        if(fixtureManager.count == 1){
            fixtureManager[0].playFixtureById(fixtureId)
            fixtureManager[0].playNextFixtureWeek()
        }
        
        var fixtureFilter = "fixtureId contains '" + fixtureId + "'"
        var fixture = realm.objects(Fixture.self).filter(fixtureFilter)
        if(fixture.count == 1){
            layoutView(fixture[0])
        }
        
        
    }

    @IBAction func backAction(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
}
