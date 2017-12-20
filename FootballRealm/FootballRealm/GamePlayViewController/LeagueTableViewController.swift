//
//  LeagueTableViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 12/19/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class LeagueTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTable: UITableView!
    var cellData : Results<LeagueTableData>!
    var numOfCells : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        mTable.registerClass(LeagueTableTableViewCell.self, forCellReuseIdentifier: "customcell")
        NSBundle.mainBundle().loadNibNamed("LeagueTableHeader", owner: self, options: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        let userTeam = realm.objects(Team.self).filter("nid == 'user'")
        var team : Team!
        var table : LeagueTable!
        if(userTeam.count != 0){
            let leagueId = userTeam.first!.getLeagueId()
            cellData = realm.objects(LeagueTableData).filter("leagueId == '" + leagueId + "'").sorted("points", ascending: false)
            numOfCells = cellData.count
        }else{
            print("nah..")
            numOfCells = 0
        }
        
        mTable.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = NSBundle.mainBundle().loadNibNamed("LeagueTableHeader", owner: self, options: nil).first as? UIView {
            return header
        }else{
            let vw = UIView()
            vw.backgroundColor = UIColor.redColor()
            return vw
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeagueTableViewCell", forIndexPath: indexPath) as? LeagueTableTableViewCell
        cell!.mPositionLbl.text = String(indexPath.row + 1)
        cell!.mNameLbl.text = cellData[indexPath.row].getTeamName()
        cell!.mPointsLbl.text = String(cellData[indexPath.row].getPoints())
        cell!.mPlayedLbl.text = String(cellData[indexPath.row].getMatchesPlayed())
        
        cell!.mWinLbl.text = String(cellData[indexPath.row].getWins())
        cell!.mDrawsLbl.text = String(cellData[indexPath.row].getDraws())
        cell!.mLosesLbl.text = String(cellData[indexPath.row].getLoses())
        cell!.mGoalsForLbl.text = String(cellData[indexPath.row].getGoalsFor())
        cell!.mGoalsAgainstLbl.text = String(cellData[indexPath.row].getGoalsAgainst())
        cell!.mGoalDifferenceLbl.text = String(cellData[indexPath.row].getGoalsFor() - cellData[indexPath.row].getGoalsAgainst())

        return cell!
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfCells
    }

    
    
    @IBAction func backAction(){
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    

}
