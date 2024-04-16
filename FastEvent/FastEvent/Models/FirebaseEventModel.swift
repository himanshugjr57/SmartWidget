//
//  FirebaseEventModel.swift
//  FastEvent
//
//  Created by RaviPadshala on 11/12/23.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class FirebaseEventModel: ObservableObject {
    
//    @EnvironmentObject var manager: DataManager
    
    private var db = Firestore.firestore()
    
    func fetchData(email: String, manager: DataManager){
        db.collection("Users").document(email).addSnapshotListener { document, error in
            print("----- call Firebase ----")
            if let docu = document{
                if let data = docu.data(), !data.isEmpty{
                    if let str = data.getValueFromKey("isSave"), str.count > 0{
                        if str == "false"{
                            let dict = self.setData(dict: data)
                            self.updateData(email: email)
                            manager.updateEventData(withData: dict, widgetID: "", isWidgetShared: true)
                        }
                    }else{
                        self.updateData(email: email)
                        let dict = self.setData(dict: data)
                        manager.updateEventData(withData: dict, widgetID: "", isWidgetShared: true)
                    }
                }
            }else{
                if let err = error{
                    print("error", err.localizedDescription)
                }
            }
        }
    }
    
    
    
//    func getData(manager: DataManager){
//        db.collection("Users").document("test@gmail.com").getDocument { document, error in
//            if let docu = document{
//                if let data = docu.data(){
//                    let dict = self.setData(dict: data)
//                    manager.updateEventData(withData: dict, widgetID: "", isWidgetShared: true)
//                }else{
//                    print("No Data Found")
//                }
//            }else{
//                if let err = error{
//                    print("error", err.localizedDescription)
//                }
//            }
//        }
//    }
    
    func createUser(email: String){
        let params: [String : Any] = [:]
        
        db.collection("Users").document(email).setData(params) { error in
            if let err = error{
                print("err", err.localizedDescription)
            }
            print("user save successFully")
        }
    }
    
    func deleteUser(email: String){
        db.collection("Users").document(email).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
            else {
                print("Document successfully removed!")
            }
        }
    }
    
    func sendData(email: String, eventModel: EventModel){
        
        let params: [String : Any] = [
            EventDataType.title.rawValue: eventModel.title,
            EventDataType.icon.rawValue: eventModel.iconName,
            EventDataType.date.rawValue: eventModel.eventDate,
            EventDataType.time.rawValue: eventModel.eventTime,
            EventDataType.backgroundColorStart.rawValue: eventModel.backgroundColorStart.string,
            EventDataType.backgroundColorEnd.rawValue: eventModel.backgroundColorEnd.string,
            EventDataType.layoutStyle.rawValue: eventModel.widgetStyle.rawValue,
            EventDataType.fontColor.rawValue: eventModel.fontColor.string,
            "isSave": "false"
        ]
        
        print("Share Param", params)
        db.collection("Users").document(email).setData(params) { error in
            if let err = error{
                print("err", err.localizedDescription)
            }
            print("Share successFully")
        }
    }
    
    func updateData(email: String){
        
        let params: [String : Any] = [
            "isSave": "true"
        ]
        
        print("Update Param", params)
        
        db.collection("Users").document(email).updateData(params) { error in
            if let err = error{
                print("err", err.localizedDescription)
            }
            print("Share successFully")
        }
    }
    
    private func setData(dict: [String : Any]) -> [EventDataType: String] {
        var evetDict = [EventDataType : String]()

        if let title = dict.getValueFromKey(EventDataType.title.rawValue){
            evetDict[.title] = title
        }
        
        if let iconName = dict.getValueFromKey(EventDataType.icon.rawValue){
            evetDict[.icon] = iconName
        }
        
//        if let iconName = dict.getValueFromKey(EventDataType.icon.rawValue){
//            evetDict[.icon] = iconName
//        }
        
        if let eventDate = dict.getValueFromKey(EventDataType.date.rawValue){
            evetDict[.date] = eventDate
        }
        
        if let eventTime = dict.getValueFromKey(EventDataType.time.rawValue){
            evetDict[.time] = eventTime
        }
        
        if let backgroundColorStart = dict.getValueFromKey(EventDataType.backgroundColorStart.rawValue){
            evetDict[.backgroundColorStart] = backgroundColorStart
        }
        
        if let backgroundColorEnd = dict.getValueFromKey(EventDataType.backgroundColorEnd.rawValue){
            evetDict[.backgroundColorEnd] = backgroundColorEnd
        }
        
        if let widgetStyle = dict.getValueFromKey(EventDataType.layoutStyle.rawValue){
            evetDict[.layoutStyle] = widgetStyle
        }
        
        if let fontColor = dict.getValueFromKey(EventDataType.fontColor.rawValue){
            evetDict[.fontColor] = fontColor
        }
//        if let location = dict.getValueFromKey(EventDataType.location.rawValue){
//            evetDict[.location] = location
//        }
        
        return evetDict
    }
}

extension [String : Any] {
    func getValueFromKey(_ key: String) -> String? {
        return (self[key] as? String)
    }
}

