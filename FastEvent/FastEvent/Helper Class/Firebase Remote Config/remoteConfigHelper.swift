//
//  RemoteConfig.swift
//  Recure
//
//  Created by Ravi Padshala on 28/07/23.
//

import Foundation
import FirebaseRemoteConfig

struct AdUnitId {
    static var feedbackEmailId = ""
    static var Re_Review_Count = Int()
    static var Review_Count = Int()
}

struct RemoteConfigParams {
    static let feedbackEmailId = "feedback_emailId"
    static let Re_Review_Count = "iOS_Re_Review_Count"
    static let Review_Count = "iOS_Review_Count"
}

class RemoteConfigHelper {
    
    static let sharedInstance = RemoteConfigHelper()
    var remoteConfig: RemoteConfig!
    
    func setup() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
   
    func fetchRemoteConfig() {
        self.remoteConfig.fetchAndActivate { status, error in
            guard error == nil else { return print(error?.localizedDescription as Any) }
            print("Ads error",error?.localizedDescription as Any)
            print("Remote config successfully fetched!", status)
            AdUnitId.feedbackEmailId = self.FeedbackEmailId()
            AdUnitId.Re_Review_Count = self.Re_Review_Count()
            AdUnitId.Review_Count = self.Review_Count()
            
            let Review_Count = AdUnitId.Review_Count
            if Review_Count != Defaults[.ReviewCount] {
                Defaults[.ReviewCount] = Review_Count
            }
            
            let Re_Review_Count = AdUnitId.Re_Review_Count
            if Re_Review_Count != Defaults[.ReReviewCount] {
                Defaults[.ReReviewCount] = Re_Review_Count
            }
        }
    }
    
    func FeedbackEmailId() -> String{
        return self.remoteConfig[RemoteConfigParams.feedbackEmailId].stringValue ?? ""
    }
    
    func Re_Review_Count() -> Int{
        return self.remoteConfig[RemoteConfigParams.Re_Review_Count].numberValue.intValue
    }
    
    func Review_Count() -> Int{
        return self.remoteConfig[RemoteConfigParams.Review_Count].numberValue.intValue
    }
}
