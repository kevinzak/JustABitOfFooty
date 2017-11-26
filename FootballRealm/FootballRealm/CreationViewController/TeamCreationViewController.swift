//
//  TeamCreationViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 4/22/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class TeamCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate  {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var clubNameTextView: UITextField!
//    @IBOutlet weak var rootPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        clubNameTextView.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)

        let realm = try! Realm()
        let userTeam = realm.objects(Team.self).filter("nid == 'user'")
        // If we have a created team
        if(userTeam.count != 0){
            clubNameTextView.text = userTeam[0].getCity() + " FC";
        }
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 10)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = pickerData[row]
        
        return pickerLabel!;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldDidChange(textField: UITextField){
        if(textField.text != ""){
            continueBtn.enabled = true
        }else{
            continueBtn.enabled = false
        }
    }
    
    @IBAction func finishedCreatingTeam(){
        let realm = try! Realm()
        let userTeam = realm.objects(Team.self).filter("nid == 'user'")
        // If we have a created team
        var team : Team!
        if(userTeam.count != 0){
            team = userTeam[0]
            try! realm.write {
                team.setTeamName(clubNameTextView.text!)
                realm.add(team)
            }
            
            
            
            // Done creating team, add them boys to the league and gen those fixtures
            let leagues = realm.objects(League.self).filter("league_id == 'Eng_1'")
            if(leagues.count != 0){
                leagues[0].acceptNewTeams([team])
                leagues[0].updateTeams()
            }

        }else{
            print("TeamCreationViewController::setData - ERROR: Could not find user team when setting Club Name")
        }
        
        
    }

}
