//
//  ManagerSelectionViewController.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 11/26/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class ManagerSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    var managerCollectionView : UICollectionView!

    // Dynamic labels that update
    var mNameLbl : UILabel = UILabel()
    var mCoachingLbl : UILabel = UILabel()
    var mTacticalLbl : UILabel = UILabel()
    var mTransferLbl : UILabel = UILabel()
    var mManManagementLbl : UILabel = UILabel()

    // Constant prefacing labels
    var kCoachingLbl : UILabel = UILabel()
    var kTacticalLbl : UILabel = UILabel()
    var kTransferLbl : UILabel = UILabel()
    var kManManagementLbl : UILabel = UILabel()
    
    // List of managers
    var mManagers : [Manager] = []
    var mSelectedManagerIndex : Int = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.enabled = false
        continueBtn.hidden = true

        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        managerCollectionView = UICollectionView(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: flowLayout)
        managerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        managerCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        managerCollectionView.delegate = self
        managerCollectionView.dataSource = self
        managerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        managerCollectionView.backgroundColor = UIColor.cyanColor()
        
        // Setup dynamic labels
        mNameLbl.text = "Name will go here."
        mNameLbl.translatesAutoresizingMaskIntoConstraints = false
        mNameLbl.textAlignment = .Center
        
        mCoachingLbl.text = "-"
        mCoachingLbl.translatesAutoresizingMaskIntoConstraints = false
        
        mTacticalLbl.text = "-"
        mTacticalLbl.translatesAutoresizingMaskIntoConstraints = false
        
        mTransferLbl.text = "-"
        mTransferLbl.translatesAutoresizingMaskIntoConstraints = false
        
        mManManagementLbl.text = "-"
        mManManagementLbl.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Setup constant labels
        kCoachingLbl.text = "Coaching Ability: "
        kCoachingLbl.translatesAutoresizingMaskIntoConstraints = false
        
        kTacticalLbl.text = "Tactical Ability: "
        kTacticalLbl.translatesAutoresizingMaskIntoConstraints = false
        
        kTransferLbl.text = "Transfers: "
        kTransferLbl.translatesAutoresizingMaskIntoConstraints = false
        
        kManManagementLbl.text = "Man Management: "
        kManManagementLbl.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(managerCollectionView)
        self.view.addSubview(mNameLbl)
        self.view.addSubview(mCoachingLbl)
        self.view.addSubview(mTacticalLbl)
        self.view.addSubview(mTransferLbl)
        self.view.addSubview(mManManagementLbl)
        
        self.view.addSubview(kCoachingLbl)
        self.view.addSubview(kTacticalLbl)
        self.view.addSubview(kTransferLbl)
        self.view.addSubview(kManManagementLbl)
        
        
        setupConstraints()
        generateManagers()
    }
    
    
    func setupConstraints(){
        var viewsAutoLayoutDict : Dictionary<String, UIView> = Dictionary<String, UIView> ()
        var metricDict :  Dictionary<String, CGFloat> = Dictionary<String, CGFloat>()
        
        viewsAutoLayoutDict["title"] = titleLbl
        viewsAutoLayoutDict["managers"] = managerCollectionView
        
        viewsAutoLayoutDict["nameLbl"] = mNameLbl
        viewsAutoLayoutDict["coachingLbl"] = mCoachingLbl
        viewsAutoLayoutDict["tacticalLbl"] = mTacticalLbl
        viewsAutoLayoutDict["transferLbl"] = mTransferLbl
        viewsAutoLayoutDict["manManagementLbl"] = mManManagementLbl
        
        
        viewsAutoLayoutDict["kCoachingLbl"] = kCoachingLbl
        viewsAutoLayoutDict["kTacticalLbl"] = kTacticalLbl
        viewsAutoLayoutDict["kTransferLbl"] = kTransferLbl
        viewsAutoLayoutDict["kManManagementLbl"] = kManManagementLbl
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[managers]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[nameLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kCoachingLbl][coachingLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kTacticalLbl][tacticalLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kTransferLbl][transferLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[kManManagementLbl][manManagementLbl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[title]-[managers(125)]-[nameLbl]-[kCoachingLbl]-[kTacticalLbl]-[kTransferLbl]-[kManManagementLbl]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsAutoLayoutDict))
        
        
        let coachContraint = NSLayoutConstraint(
            item: mCoachingLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kCoachingLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        let tacticalContraint = NSLayoutConstraint(
            item: mTacticalLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kTacticalLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        let transferContraint = NSLayoutConstraint(
            item: mTransferLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kTransferLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        let manManagementContraint = NSLayoutConstraint(
            item: mManManagementLbl,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.kManManagementLbl,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        
        view.addConstraint(coachContraint)
        view.addConstraint(tacticalContraint)
        view.addConstraint(transferContraint)
        view.addConstraint(manManagementContraint)
    }
    
    func updateLabelsWithLocationData(manager: Manager){
        mNameLbl.text = manager.firstName + " " + manager.lastName
        mCoachingLbl.text = String(manager.getCoachingRating())
        mTacticalLbl.text = String(manager.getTacticalRating())
        mTransferLbl.text = String(manager.getTransferRating())
        mManManagementLbl.text = String(manager.getManManagementRating())
    }
    
    func generateManagers(){
        let numofManagers = 5
        for(var i = 0; i < numofManagers; i++){
            let manager = ManagerFactory.sharedInstance.generateManager(20);
            mManagers.insert(manager, atIndex: 0)
        }
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
        return mManagers.count
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
        mSelectedManagerIndex = indexPath.item
        updateLabelsWithLocationData(mManagers[indexPath.item])
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
                if(mSelectedManagerIndex >= 0){
                    team.setManager(mManagers[mSelectedManagerIndex])
                }else{
                    team.setManager(mManagers[0])
                }
                realm.add(team)
            }
        }else{
            print("LocationSelectionViewController::setData - ERROR: Could not find user team when setting location model")
        }
    }



}
