//
//  PreviewSampleData.swift
//  TodoApp
//
//  Created by Karin Prater on 01.08.23.
//

import Foundation
import SwiftData

let container: ModelContainer = {
    do {
        let groupContainer = ModelConfiguration.GroupContainer.identifier(AppConfig.appGroup)
        let configuration = ModelConfiguration(groupContainer: groupContainer)
        let previewContainer = try ModelContainer(for: EventModel.self, configurations: configuration)
        
//        Task {
//            @MainActor in getAllObjects()
//        }
        return previewContainer
    } catch {
        fatalError("Failed to create a container")
    }
}()
