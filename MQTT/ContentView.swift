//
//  ContentView.swift
//  MQTT
//
//  Created by Bruno Chen on 23/02/23.
//

import SwiftUI

struct ContentView: View {
    
    // View model
    @ObservedObject var viewModel: MQTTViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("MQTT Server URL:")
                .fontWeight(.bold)
            TextField("broker.hivemq.com", text: $viewModel.url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Text("Topic:")
                .fontWeight(.bold)
            TextField("", text: $viewModel.topic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            HStack {
                Text("Publish Message:")
                    .fontWeight(.bold)
                
                Picker(selection: $viewModel.qosOption, label: Text("")) {
                    Text("At Most Once").tag(0)
                    Text("At Least Once").tag(1)
                    Text("Exactly Once").tag(2)
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            TextField("", text: $viewModel.publishText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Text("Username:")
                .fontWeight(.bold)
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Text("Password:")
                .fontWeight(.bold)
            TextField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        HStack {
            Group {
                Button(action: viewModel.connect) {
                    Text("Connect")
                        .border(Color.blue, width: 1)
                }
                
                Button(action: viewModel.disconnect) {
                    Text("Disconnect")
                        .border(Color.blue, width: 1)
                }
                
                Button(action: viewModel.subscribe) {
                    Text("Subs")
                        .border(Color.blue, width: 1)
                }
                
                Button(action: viewModel.publish) {
                    Text("Publish")
                        .border(Color.blue, width: 1)
                }
                
                Button(action: viewModel.clear) {
                    Text("Clear")
                        .border(Color.blue, width: 1)
                }
            }
            .buttonStyle(DefaultButtonStyle())
        }
        .padding()
        
        Text("Broker Log:")
            .fontWeight(.bold)
        ScrollView {
            Text(viewModel.log)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
            )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MQTTViewModel())
    }
}
