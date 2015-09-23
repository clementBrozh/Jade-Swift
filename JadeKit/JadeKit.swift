//
//  JadeKit.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 23/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import Foundation

public func getBusLive(completion: ([JKBus], NSError?) -> Void) {
    JKDataExploreService.getBusLive(completion)
}