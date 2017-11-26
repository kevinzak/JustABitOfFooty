//
//  LocationSelectionViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 5/20/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class LocationSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var ViewControllerTitleLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!

    var locationCollectionView : UICollectionView!

    // Dynamic labels that update
    var mNameLbl : UILabel = UILabel()
    var mTypeLbl : UILabel = UILabel()
    var mPitchLbl : UILabel = UILabel()
    var mAccessLbl : UILabel = UILabel()
    var mAreaLbl : UILabel = UILabel()

    // Constant prefacing labels
    var kTypeLbl : UILabel = UILabel()
    var kPitchLbl : UILabel = UILabel()
    var kAccessLbl : UILabel = UILabel()
    var kAreaLbl : UILabel = UILabel()

    // List of locations
    var mLocations : [LocationModel] = []
    var mSelectedLocationIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.enabled = false
        continueBtn.hidden = true
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        let locs = realm.objects(LocationModel.self)
        for location in locs{
            mLocations.append(location)
        }
        
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
        mNameLbl.text = "Name will go here."
        mNameLbl.translatesAutoresizingMaskIntoConstraints = false
        mNameLbl.textAlignment = .Center

        mTypeLbl.text = "-"
        mTypeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        mPitchLbl.text = "-"
        mPitchLbl.translatesAutoresizingMaskIntoConstraints = false

        mAccessLbl.text = "-"
        mAccessLbl.translatesAutoresizingMaskIntoConstraints = false

        mAreaLbl.text = "-"
        mAreaLbl.translatesAutoresizingMaskIntoConstraints = false


        // Setup constant labels
        kTypeLbl.text = "Type: "
        kTypeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        kPitchLbl.text = "Pitch Quality: "
        kPitchLbl.translatesAutoresizingMaskIntoConstraints = false
        
        kAccessLbl.text = "Accessibility: "
        kAccessLbl.translatesAutoresizingMaskIntoConstraints = false
        
        kAreaLbl.text = "Desireability: "
        kAreaLbl.translatesAutoresizingMaskIntoConstraints = false

        
        self.view.addSubview(locationCollectionView)
        self.view.addSubview(mNameLbl)
        self.view.addSubview(mTypeLbl)
        self.view.addSubview(mPitchLbl)
        self.view.addSubview(mAccessLbl)
        self.view.addSubview(mAreaLbl)
        
        self.view.addSubview(kTypeLbl)
        self.view.addSubview(kPitchLbl)
        self.view.addSubview(kAccessLbl)
        self.view.addSubview(kAreaLbl)


        setupConstraints()
    }

    func setupConstraints(){
        var viewsAutoLayoutDict : Dictionary<String, UIView> = Dictionary<String, UIView> ()
        var metricDict :  Dictionary<String, CGFloat> = Dictionary<String, CGFloat>()
        
        viewsAutoLayoutDict["title"] = ViewControllerTitleLabel
        viewsAutoLayoutDict["locations"] = locationCollectionView
        
        viewsAutoLayoutDict["nameLbl"] = mNameLbl
        viewsAutoLayoutDict["typeLbl"] = mTypeLbl
        viewsAutoLayoutDict["pitchLbl"] = mPitchLbl
        viewsAutoLayoutDict["accessLbl"] = mAccessLbl
        viewsAutoLayoutDict["areaLbl"] = mAreaLbl


        viewsAutoLayoutDict["kTypeLbl"] = kTypeLbl
        viewsAutoLayoutDict["kPitchLbl"] = kPitchLbl
        viewsAutoLayoutDict["kAccessLbl"] = kAccessLbl
        viewsAutoLayoutDict["kAreaLbl"] = kAreaLbl
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[locations]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[nameLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kTypeLbl][typeLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kPitchLbl][pitchLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kAccessLbl][accessLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kAreaLbl][areaLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))

        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[title]-[locations(125)]-[nameLbl]-[kTypeLbl]-[kPitchLbl]-[kAccessLbl]-[kAreaLbl]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))

        
        let typeContraint = NSLayoutConstraint(
            item: mTypeLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kTypeLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)

        let pitchContraint = NSLayoutConstraint(
            item: mPitchLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kPitchLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        
        let accessContraint = NSLayoutConstraint(
            item: mAccessLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kAccessLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        let areaContraint = NSLayoutConstraint(
            item: mAreaLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kAreaLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        
        view.addConstraint(typeContraint)
        view.addConstraint(pitchContraint)
        view.addConstraint(accessContraint)
        view.addConstraint(areaContraint)
    }
    
    func updateLabelsWithLocationData(location: LocationModel){
        mNameLbl.text = location.getName()
        mTypeLbl.text = location.getType()
        mPitchLbl.text = String(location.getPitchQuality())
        mAccessLbl.text = String(location.getAccessibility())
        mAreaLbl.text = String(location.getAreaDesirability())
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
        return mLocations.count
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
        mSelectedLocationIndex = indexPath.item
        updateLabelsWithLocationData(mLocations[indexPath.item])
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
                if(mSelectedLocationIndex >= 0){
                    team.setGround(mLocations[mSelectedLocationIndex])
                }else{
                    team.setGround(mLocations[0])
                }
                realm.add(team)
            }
        }else{
            print("LocationSelectionViewController::setData - ERROR: Could not find user team when setting location model")
        }
    }

}
