//
//  PlayerFactory.swift
//  FootballRealm
//
//  Created by Kevin Zakszewski on 4/17/17.
//  Copyright © 2017 Kevin Zakszewski. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerFactory {
    let GK_PER_TEAM = 3
    let DEF_PER_TEAM = 8
    let MID_PER_TEAM = 8
    let ATK_PER_TEAM = 5

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    static let sharedInstance = PlayerFactory()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    func generateTeam()->[Player]{
        var allPlayers :[Player] = []

        allPlayers.appendContentsOf(generateGoalkeepers(GK_PER_TEAM))
        allPlayers.appendContentsOf(generateDefenders(DEF_PER_TEAM))
        allPlayers.appendContentsOf(generateMidfielders(MID_PER_TEAM))
        allPlayers.appendContentsOf(generateAttackers(ATK_PER_TEAM))

        return allPlayers
    }
    

    func generateGoalkeepers(num : Int = 3)->List<Player>{
        var goalkeepers = List<Player>()
        for(var i = 0; i < num; i++){
            goalkeepers.append(generatePlayer("GK"))
        }
        return goalkeepers
    }

    func generateDefenders(num : Int = 8)->List<Player>{
        var defenders = List<Player>()
        for(var i = 0; i < num; i++){
            defenders.append(generatePlayer("DEF"))
        }
        return defenders
    }

    func generateMidfielders(num : Int = 8)->List<Player>{
        var midfielders  = List<Player>()
        for(var i = 0; i < num; i++){
            midfielders.append(generatePlayer("MID"))
        }
        return midfielders
    }

    func generateAttackers(num : Int = 5)->List<Player>{
        var attackers  = List<Player>()
        for(var i = 0; i < num; i++){
            attackers.append(generatePlayer("ATK"))
        }
        return attackers
    }


    private func generatePlayer(pos: String)->Player{
        var length = UInt32 (self.surnames.count)
        var rand = Int(arc4random_uniform(length))
        let rating = Float(arc4random_uniform(50) + 50)
        
        let firstName = (self.randomStringWithLength(1) as String) + "."
        let surname = self.surnames[rand]
        let player = Player(firstName: firstName, surname: surname, pos: pos, overalRating: rating)

        let realm = try! Realm()
        try! realm.write {
            realm.add(player)
        }

        return player
    }
    
    //
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }

    
    
    var surnames : [String] = [
        "ABERNETHY",
        "ADAM",
        "ADCOCK",
        "ALDRIDGE",
        "ALLAN",
        "ANDREWS",
        "ARESOME",
        "ARNOLD",
        "BAKER",
        "BARBER",
        "BARLOW",
        "BARNET",
        "BELL",
        "BENTON",
        "BIRCH",
        "BLACKAMORE",
        "BLAIKIE",
        "BLANCHFLOWER",
        "BOELL",
        "BOOTH",
        "BOULTER",
        "BOUSAR",
        "BOWES",
        "BOWSER",
        "BOYDEN",
        "BRADFIELD",
        "BRANDY",
        "BREMNER",
        "BRIDE",
        "BROCKE",
        "BROCKIE",
        "BROOKE",
        "BROOMFIELD",
        "BROWN",
        "BROWNFIELD",
        "BRUER",
        "BUIE",
        "BULL",
        "BUSHELL",
        "CAKEBREAD",
        "CAMERON",
        "CAMPBELL",
        "CANNE",
        "CHALMERS",
        "CHAMBERLANE",
        "CHAMBERS",
        "CHARLES",
        "CHISHOLM",
        "CHISSET",
        "CHRISTIE",
        "CLARKE",
        "CLERK",
        "CLOSE",
        "COCKEN",
        "COOKE",
        "COPELAND",
        "CORKEN",
        "COUDAN",
        "COUPLAND",
        "COVERDALE",
        "COWDEN",
        "COWPER",
        "CRANSTON",
        "CRICHTON",
        "CRUICKSHANK",
        "DAKIN",
        "DAKION",
        "DALLACHIE",
        "DAMMANN",
        "DAVIDSON",
        "DELL",
        "DELPH",
        "DINGWALL",
        "DOUBLEDAY",
        "DOUBLEDEW",
        "DOUGLAS",
        "DRUMMOND",
        "DUCKE",
        "DUFF",
        "DUKE",
        "DUNCAN",
        "EDMONDSTONE",
        "EGGE",
        "ELDER",
        "ELLIS",
        "ELPHINSTONE",
        "ENGLEDEW",
        "ERSKINE",
        "EVERET",
        "FAIRLEY",
        "FEAKE",
        "FINDLAY",
        "FISHER",
        "FISKE",
        "FLEMING",
        "FLUNDERS",
        "FORBES",
        "FORBES-HOOD",
        "FORSYTH",
        "FRAMINGHAM",
        "FRIER",
        "GAIRDNE",
        "GARBUT",
        "GARMAN",
        "GAVENS",
        "GEDDES",
        "GERRARD",
        "GIBSON",
        "GILL",
        "GORDON",
        "GRAHAM",
        "GRANT",
        "GRINLAW",
        "HAENCKE",
        "HALL",
        "HAMILTON",
        "HANNUM",
        "HANSCOMBE",
        "HARDEN",
        "HARDER",
        "HARDING",
        "HARLAND",
        "HARWOOD",
        "HASS",
        "HAY",
        "HENRIE",
        "HENRY",
        "HEPBURN",
        "HILLIARD",
        "HILLS",
        "HINGST",
        "HIRD",
        "HODGSON",
        "HOLLINGWORTH",
        "HOLLOWAY",
        "HOOD",
        "HOOKES",
        "HORN",
        "HOWLET",
        "HUET",
        "HUME",
        "INGLEDEW",
        "INNES",
        "IRONSYD",
        "JACKSON",
        "JENNINGS",
        "JOHNSTONE",
        "JONES",
        "JUNGE",
        "KEITH",
        "KENNEDY",
        "KENT",
        "KER",
        "KID",
        "KINNIE",
        "KINNIS",
        "LADIKEN",
        "LAUREN",
        "LAWRENCE",
        "LEAD",
        "LEES",
        "LEIGHBODY",
        "LIGHTBODY",
        "LIVINGSTON",
        "LODGE",
        "LORRAIN",
        "LUMSDEN",
        "MACKENZIE",
        "MACKINTOSH",
        "MCCARMICK",
        "MCCLURG",
        "MCCOLM",
        "MCCOMB",
        "MCCULLOCH",
        "MCGAA",
        "MCGUFFOG",
        "MCINTOSH",
        "MCKINTOSH",
        "MCLURG",
        "MCMASTER",
        "MAIR",
        "MAITLAND",
        "MAN",
        "MANSFIELD",
        "MAPLETON",
        "MARTINE",
        "MATHESON",
        "MAYES",
        "MEIN",
        "MEINDERS",
        "MEINERD",
        "MEYFART",
        "MEYFORT",
        "MEYVERT",
        "MILLS",
        "MILNE",
        "MORDISON",
        "MORITZ",
        "MORRISON",
        "MURDISTON",
        "MURRAY",
        "NICHOLS",
        "NOBLE",
        "OGILVIE",
        "OGILVY",
        "PALLET",
        "PARLETT",
        "PATERSON",
        "PATRICKE",
        "PECK",
        "PHERSON",
        "PIRIE",
        "PLAMBECK",
        "PORTER",
        "PRATT",
        "PRESSED",
        "PRESSICK",
        "PRIOR",
        "PRISSICK",
        "RAITT",
        "RAW",
        "RAYMENT",
        "REDWYNE",
        "REID",
        "REIDFORD",
        "REIDFURD",
        "RICKET",
        "RIDER",
        "RIGG",
        "ROBERSON",
        "ROWE",
        "RUSSEL",
        "SANDILANDS",
        "SANDISON",
        "SCHEEL",
        "SCHLUETER",
        "SCHNOOR",
        "SCOTT",
        "SEAMAN",
        "SECKER",
        "SETON",
        "SHADBOLT",
        "SHAND",
        "SHAW",
        "SHIELL",
        "SHIMEN",
        "SHIMMEN",
        "SHIMMING",
        "SHORT",
        "SHOTBOLT",
        "SIEVERS",
        "SIM",
        "SKEGG",
        "SLUETERS",
        "SMAIL",
        "SMITH",
        "SNAWDON",
        "STEINSON",
        "STEPHEN",
        "STEPHENSON",
        "STEVEN",
        "STEVENSON",
        "STEVINSON",
        "STEWART",
        "STOKES",
        "STUART",
        "SUMNER",
        "SUMPTER",
        "SUTHERLAND",
        "TAIT",
        "TAYLOR",
        "THOMSON",
        "TICKELL",
        "TOLLER",
        "TOSH",
        "TURNER",
        "UNCKLE",
        "URQUHART",
        "USHER",
        "VINCENT",
        "VOLMERS",
        "VOSS",
        "WALKER",
        "WARD",
        "WARMAN",
        "WARREN",
        "WAUGH",
        "WEBB",
        "WEBSTER",
        "WEIR",
        "WELD",
        "WEST",
        "WHITE",
        "WIEBENSOHN",
        "WILLIAMS",
        "WILSON",
        "WOERGEL",
        "WOERPEL",
        "WOOD",
        "WREN",
        "WRIGHT"
    ]


}
