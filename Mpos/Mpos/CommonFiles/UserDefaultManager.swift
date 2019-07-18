//
//  AppDelegate.swift
//  Mpos
//
//  Created by Kevin on 17/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

class UserDefaultManager: NSObject
{
    static let SharedInstance = UserDefaultManager()
    
    //User
    func saveLoggedUser(dict:[String:Any]) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: dict)
        let defaut = UserDefaults.standard
        defaut.set(encodedData, forKey:UserDefaultKey.LOGIN_USER.rawValue)
        defaut.synchronize()
    }
    
    func getLoggedUser() -> Dictionary<String, Any>?
    {
        let defaut = UserDefaults.standard
        let data = defaut.object(forKey: UserDefaultKey.LOGIN_USER.rawValue)
        if (data != nil) {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            return decodedTeams as? Dictionary<String, Any>
        } else {
            return nil
        }
    }
    func removeUser()
    {
        let defaut = UserDefaults.standard
        defaut.removeObject(forKey: UserDefaultKey.LOGIN_USER.rawValue)
        defaut.set(false, forKey: UserDefaultKey.IS_USERLOGGEDIN.rawValue)
        defaut.set(false, forKey: UserDefaultKey.IS_ONBOARDINGDONE.rawValue)
        defaut.synchronize()
        
    }
    
    //Token
    func saveToken(str:String) {
        let defaut = UserDefaults.standard
        defaut.set(str, forKey: UserDefaultKey.TOKEN.rawValue)
        defaut.synchronize()
    }
    func getToken() -> String? {
        let defaut = UserDefaults.standard
        let token:String? = defaut.object(forKey: UserDefaultKey.TOKEN.rawValue) as? String
        return token
    }

    func setUserLoggedIn(isLogin:Bool) {
        let defaut = UserDefaults.standard
        defaut.set(isLogin, forKey: UserDefaultKey.IS_USERLOGGEDIN.rawValue)
        defaut.synchronize()
    }
    func isUserLoggedIn() -> Bool {
        let defaut = UserDefaults.standard
        let islogin = defaut.bool(forKey: UserDefaultKey.IS_USERLOGGEDIN.rawValue)
        return islogin
    }
    
 
    func setOnboardingCmplete(isComplete:Bool) {
        
        let defaut = UserDefaults.standard
        defaut.set(isComplete, forKey: UserDefaultKey.IS_ONBOARDINGDONE.rawValue)
        defaut.synchronize()
    }
    
    func isOnboardingComplete() -> Bool {
        let defaut = UserDefaults.standard
        let isComplete = defaut.bool(forKey: UserDefaultKey.IS_ONBOARDINGDONE.rawValue)
        return isComplete
    }
    
   
}

