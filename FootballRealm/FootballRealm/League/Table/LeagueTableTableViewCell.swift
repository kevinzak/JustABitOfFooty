//
//  LeagueTableTableViewCell.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 12/19/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit

class LeagueTableTableViewCell: UITableViewCell {

    @IBOutlet weak var mPositionLbl: UILabel!
    @IBOutlet weak var mNameLbl: UILabel!
    @IBOutlet weak var mPointsLbl: UILabel!
    @IBOutlet weak var mGoalDifferenceLbl: UILabel!
    @IBOutlet weak var mGoalsAgainstLbl: UILabel!
    @IBOutlet weak var mGoalsForLbl: UILabel!
    @IBOutlet weak var mLosesLbl: UILabel!
    @IBOutlet weak var mDrawsLbl: UILabel!
    @IBOutlet weak var mWinLbl: UILabel!
    @IBOutlet weak var mPlayedLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
