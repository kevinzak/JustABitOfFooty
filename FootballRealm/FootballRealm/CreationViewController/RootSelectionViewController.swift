//
//  RootSelectionViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 7/19/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class RootSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate {
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var rootPicker: UIPickerView!

    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        clubNameTextView.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        rootPicker.dataSource = self
        rootPicker.delegate = self
        pickerData = ["Working Club", "Parish Club", "Athletic Club", "Wealthy Club", "Royalty Club", "Community/Local Club" ]
        
        
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
        
        let atk = Float(arc4random_uniform(50) + 50)
        let mid = Float(arc4random_uniform(50) + 50)
        let def = Float(arc4random_uniform(50) + 50)
        let glk = Float(arc4random_uniform(50) + 50)
        
        let team = Team(id: "user", name: "Placeholder FC", attack: atk, midfield: mid, defense: def, goalkeeper: glk  )
        
        try! realm.write {
            realm.add(team)
        }
        
    }
    
}
