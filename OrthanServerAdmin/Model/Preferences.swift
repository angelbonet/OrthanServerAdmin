//
//  Preferences.swift
//  OrthancServerAdmin
//
//  Created by admin on 13/03/2019.
//  Copyright © 2019 Innovaorto. All rights reserved.
//

import Foundation

struct Preferences {
    
    var startPref: NSInteger
    var startServerPrefs: NSInteger {
        get {
            let startPref = UserDefaults.standard.integer(forKey: "startPrefCheck")
            return startPref
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "startPrefCheck")
        }
    }
    
}
