//
//  UserProfileControl.swift
//  mfc
//
//  Created by Shamil Chomaev on 24.10.2020.
//

import Foundation

struct UserProfileControl {
    
    static let defaults = UserDefaults.standard
    
    //Status user data (false - no data)
    static func SetUserStatus(tp: String) {
        if tp == "admin" {
            defaults.set(true, forKey: "UDControlUserStatus")
            print("SetUserStatus true")
        } else {
            defaults.set(false, forKey: "UDControlUserStatus")
            print("SetUserStatus false")
        }
    }
    
    static func DeleteUserStatus() {
        defaults.set(false, forKey: "UDControlUserStatus")
        print("DeleteUserStatus false")
    }
    
    //Status user data (false - no data)
    static func UserStatus() -> Bool {
        var status: Bool = false
        status = defaults.bool(forKey: "UDControlUserStatus")
        print("UserStatus \(status)")
        return status
    }
}
