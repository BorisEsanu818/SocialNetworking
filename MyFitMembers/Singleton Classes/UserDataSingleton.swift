//
//  SDataSingleton.swift
//  Glam360
//
//  Created by cbl16 on 7/5/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import RMMapper

class UserDataSingleton {
        
        private static var __once: () = {
                Static.instance = UserDataSingleton()
            }()
        
        class var sharedInstance: UserDataSingleton {
            struct Static {
                static var instance: UserDataSingleton?
                static var token: Int = 0
            }
            
            _ = UserDataSingleton.__once
            
            return Static.instance!
    }
    
    
    var loggedInUser : User?{
        get{
            var user : User?
            if let data = UserDefaults.standard.rm_customObject(forKey: "profile") as? User{
                user = data
            }
            return user
        }
        set{
            let defaults = UserDefaults.standard
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "profile")
            }
            else{
                defaults.removeObject(forKey: "profile")
            }
        }
    }
    var fitnessAssesment : FitnessAssesment?{
        get{
             return UserDefaults.standard.rm_customObject(forKey: "CurrentCustomerFitnessAssesment") as? FitnessAssesment
        }
        set{
            let defaults = UserDefaults.standard
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "CurrentCustomerFitnessAssesment")
            }
            else{
                defaults.removeObject(forKey: "CurrentCustomerFitnessAssesment")
            }
        }
    }
    
    var fitnessAssesment1 : FitnessAssesment1?{
        get{
            return UserDefaults.standard.rm_customObject(forKey: "CurrentCustomerFitnessAssesment1") as? FitnessAssesment1
        }
        set{
            let defaults = UserDefaults.standard
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "CurrentCustomerFitnessAssesment1")
            }
            else{
                defaults.removeObject(forKey: "CurrentCustomerFitnessAssesment1")
            }
        }
    }
    
    var pushDict: NSDictionary?

    
    

}
