//
//  AppLockViewModel.swift
//  SketchApp
//
//  Created by MANAS VIJAYWARGIYA on 15/08/21.
//

import Foundation
import LocalAuthentication

class AppLockViewModel: ObservableObject {
    @Published var isAppLockEnabled: Bool = true
    @Published var isAppUnlocked : Bool = true
    
    init() {
        getAppLockStatus()
    }
    
    func enableAppLock() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = true
    }
    
    func disableAppLock() {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = false
    }
    
    func getAppLockStatus() {
        isAppLockEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
    }
    
    func checkIfBioMetricAvailble()  -> Bool {
        var error: NSError?
        let laContext = LAContext()
        let isBiometricAvaiable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            print(error.localizedDescription)
        }
        
        return isBiometricAvaiable
    }
    
    func appLockStateChange(appLockState: Bool) {
        let laContext = LAContext()
        
        if checkIfBioMetricAvailble() {
            var reason = ""
            if appLockState {
                reason = "Provide TouchID / FaceID to enable App Lock"
            } else {
                reason = "Provide TouchID / FaceID to disable App Lock"
            }
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    if appLockState {
                        DispatchQueue.main.async {
                            self.enableAppLock()
                            self.isAppUnlocked = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.disableAppLock()
                            self.isAppUnlocked = true
                        }
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func appLockValidation() {
        let laContext = LAContext()
        if checkIfBioMetricAvailble() {
            let reason = "Enable App Lock"
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { succes, error in
                if succes {
                    DispatchQueue.main.async {
                        self.isAppUnlocked = true
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
        }
    }
}
 
enum UserDefaultsKeys: String {
    case isAppLockEnabled
}
