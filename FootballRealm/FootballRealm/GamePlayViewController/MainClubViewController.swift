//
//  MainClubViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 6/5/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//
// This controlls playing game weeks, seasons, printing table, printing stats. 
// Most Club functions will stem from this view controller

import UIKit
import RealmSwift

class MainClubViewController: UIViewController {

    var mLeagueManager : LeagueManager!
    var mLeagueTableViewController : LeagueTableViewController!
    var mMatchViewController : MatchViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mLeagueManager = LeagueManager()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    @IBAction func displayTeamManagers(){
        mLeagueManager?.displayTeamManagers()
    }

    
    @IBAction func showLeagueTable(){
        if mLeagueTableViewController == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            mLeagueTableViewController = storyboard.instantiateViewControllerWithIdentifier("leagueTableViewController") as! LeagueTableViewController
        }
        self.navigationController!.pushViewController(mLeagueTableViewController, animated: true)

    }
    
    @IBAction func playMatch(sender: AnyObject) {
        if mMatchViewController == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            mMatchViewController = storyboard.instantiateViewControllerWithIdentifier("matchViewController") as! MatchViewController
        }
        self.navigationController!.pushViewController(mMatchViewController, animated: true)
    }
    

}
