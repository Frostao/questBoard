//
//  ServerConstant.swift
//  QuestBoard
//
//  Created by Siyuan Gao on 3/23/15.
//  Copyright (c) 2015 Purdue Bang. All rights reserved.
//

import Foundation

private let _sharedInstance = ServerConst()

class ServerConst {
    class var sharedInstance : ServerConst {
        return _sharedInstance
    }
    let serverURL = "http://nerved.herokuapp.com"
}