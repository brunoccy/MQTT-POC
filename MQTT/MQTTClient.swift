//
//  MQTTClient.swift
//  MQTT
//
//  Created by Bruno Chen on 23/02/23.
//

import CocoaMQTT
import SwiftUI

class MQTTClient: CocoaMQTTDelegate {
    
    private let mqtt: CocoaMQTT
    private weak var viewModel: MQTTViewModel?
    
    init(url: String, username: String, password: String, viewModel: MQTTViewModel) {
        self.viewModel = viewModel
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: url, port: 1883)
        mqtt.username = ""
        mqtt.password = ""
        mqtt.keepAlive = 60
        mqtt.delegate = self
    }
    
    func connect() {
        // Using Certificate
        // addCertificate()
        
        if mqtt.connect() {
            log += "Connection established\n"
        } else {
            log += "Connection failed\n"
        }
    }
    
    private func addCertificate() {
        // AWS endpoint: a3p5jdyzlggflb-ats.iot.sa-east-1.amazonaws.com
        let pemCertPath = Bundle.main.path(forResource: "certificate", ofType: "pem")
        let pemCertData = try? String(contentsOfFile: pemCertPath ?? "", encoding: .utf8)

        let keyPath = Bundle.main.path(forResource: "certificate", ofType: "key")
        let keyData = try? String(contentsOfFile: keyPath ?? "", encoding: .utf8)

        let certPath = Bundle.main.path(forResource: "certificate", ofType: "cert")
        let certData = try? String(contentsOfFile: certPath ?? "", encoding: .utf8)

        let certificates = [
            pemCertData,
            keyData,
            certData,
        ].compactMap { (stringData) -> NSData? in
            guard let data = stringData?.data(using: .utf8) else {
                return nil
            }
            return NSData(data: data)
        }
        
        mqtt.enableSSL = true
        mqtt.allowUntrustCACertificate = false
        mqtt.sslSettings = [
            kCFStreamSSLPeerName as String: kCFNull,
            kCFStreamSSLCertificates as String: certificates as NSObject,
        ]
    }
    
    func disconnect() {
        mqtt.disconnect()
    }
    
    func subscribe(topic: String) {
        mqtt.subscribe(topic)
    }
    
    func publish(topic: String, text: String, qosOption: QosOption) {
        let qos: CocoaMQTTQoS
        switch qosOption {
        case .qos0:
            qos = .qos0
        case .qos1:
            qos = .qos1
        case .qos2:
            qos = .qos2
        }
        
        mqtt.publish(CocoaMQTTMessage(topic: topic, string: text, qos: qos))
    }
    
    func clear() {
        log = ""
        viewModel?.updateLog()
    }
    
    // MARK: - CocoaMQTTDelegate
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            log += "Connected to \(mqtt.host)\n"
        } else {
            log += "Failed to connect to \(mqtt.host)\n"
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        log += "Published message to \(message.topic) with payload \(message.string!)\n"
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        log += "Subscribed to \(topic)\n"
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        log += "Unsubscribed from \(topic)\n"
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            log += "Disconnected from \(mqtt.host) with error: \(error.localizedDescription)\n"
        } else {
            log += "Disconnected from \(mqtt.host)\n"
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        log += "Received message from \(message.topic) with payload \(message.string!)\n"
        log += "\(message.string!)\n"
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        log += "Did Ping\n"
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        log += "Received Pong\n"
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        log += "Unsubscribed from \(topics)\n"
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        log += "Subscribed to topics\n"
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        log += "Published Ack\n"
    }
    
    // MARK: - Properties
    
    @Published var log = "" {
        didSet {
            viewModel?.updateLog()
        }
    }
}
