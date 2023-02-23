//
//  MQTTViewModel.swift
//  MQTT
//
//  Created by Bruno Chen on 23/02/23.
//

import SwiftUI

class MQTTViewModel: ObservableObject {
    
    @Published var url: String = "broker.hivemq.com"
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var topic: String = ""
    @Published var publishText: String = ""
    @Published var qosOption: Int = 0

    private var client: MQTTClient?
    
    func connect() {
        client = MQTTClient(url: url, username: username, password: password, viewModel: self)
        client?.connect()
    }
    
    func disconnect() {
        client?.disconnect()
    }
    
    func subscribe() {
        client?.subscribe(topic: topic)
    }
    
    func publish() {
        client?.publish(topic: topic, text: publishText, qosOption: qosOption)
    }
    
    func clear() {
        client?.clear()
    }
    
    var log: String {
        client?.log ?? ""
    }
    
    func updateLog() {
        objectWillChange.send()
    }
    
}
