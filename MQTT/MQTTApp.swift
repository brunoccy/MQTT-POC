//
//  MQTTApp.swift
//  MQTT
//
//  Created by Bruno Chen on 23/02/23.
//

import SwiftUI

@main
struct MQTTApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MQTTViewModel())
        }
    }
}
