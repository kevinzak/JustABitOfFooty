//
//  CityCreationViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 7/8/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class CityCreationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    struct city{
        var name : String!
        var desc : String!
    }
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    var locationCollectionView : UICollectionView!
    
//    var locations : [LocationModel] = []
    var cityNames : [String] = ["Huntington", "Bromwich", "Kilkenny", "Northpass", "Woodhurst", "Dunwich", "Aberswyth", "Pontybridge","Briar Glen", "Beachcastle","Oakheart", "Ormskirk", "Wandermere", "Letton"]

    var mSelectedCityNameIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        continueBtn.enabled = false
        continueBtn.hidden = true
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        locationCollectionView = UICollectionView(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: flowLayout)
        locationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        locationCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        locationCollectionView.backgroundColor = UIColor.cyanColor()

        // Setup dynamic labels

        
        // Setup constant labels
        
        self.view.addSubview(locationCollectionView)
        
        setupConstraints()

    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func setupConstraints(){
        var viewsAutoLayoutDict : Dictionary<String, UIView> = Dictionary<String, UIView> ()
        var metricDict :  Dictionary<String, CGFloat> = Dictionary<String, CGFloat>()
        
        viewsAutoLayoutDict["title"] = titleLabel
        viewsAutoLayoutDict["locations"] = locationCollectionView
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[locations]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[title]-[locations(125)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        
        
        
    }
    
    func setData(city: String){
        cityNameTextField.text = city
        
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

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cityNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath)
     
        if(cell.selected){
            cell.backgroundColor = UIColor.redColor()
        }else{
            cell.backgroundColor = UIColor.blueColor()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // If selected cell, enable continue button
        continueBtn.enabled = true
        continueBtn.hidden = false
        
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.redColor()
        mSelectedCityNameIndex = indexPath.item
        setData(cityNames[indexPath.item]);
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath){
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.blueColor()
    }
    
    
    @IBAction func continueButtonAction(){
        let realm = try! Realm()
        
        // Find user team and update their data model with selected location model
        let userTeam = realm.objects(Team.self).filter("nid == 'user'")
        var team : Team!
        if(userTeam.count != 0){
            try! realm.write {
                team = userTeam[0]
                if(cityNameTextField.text != ""){
                    team.setTeamCity(cityNameTextField.text!)
                }else{
                    team.setTeamCity(cityNames[mSelectedCityNameIndex])
                }
                realm.add(team)
            }
        }else{
            print("CityCreationViewController::setData - ERROR: Could not find user team when setting City Name")
        }
    }


}
