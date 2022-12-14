//
//  ContentView.swift
//  SitAround
//
//  Created by Jimmy Hough Jr on 12/13/22.
//

import SwiftUI
import Citadel

struct Logo:View {
    var body: some View {
        HStack {
            Image(systemName: "firewall")
            Image(systemName:"fossil.shell")
        }
    }
}

struct SSHClientView:View {
    @ObservedObject var cd = CentralDogma.shared
    
    @State var hostAddress = "localhost"
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Host")
            TextField("SSH Host", text:$cd.host)
            Button {
                Task {

                }
            } label: {
                Text("Connect to SSH")
            }

        }
    }
}

struct SSHServerView:View {
    @ObservedObject var cd = CentralDogma.shared
    
    @State var connections = [String]()
    @State var selected:String?
    
    var body: some View {
    
        VStack(alignment: .leading) {
            Text("Connections")
            List(selection: $selected) {
                ForEach(connections, id:\.self) { con in
                    Text(con)
                }
            }
        }
      
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack {
            HStack {
                SSHClientView()
                SSHServerView()
            }
        }
        .padding()
    }
}
