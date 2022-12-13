//
//  CentralDogma.swift
//  SitAround
//
//  Created by Jimmy Hough Jr on 12/13/22.
//

import Foundation
import SwiftUI
import Citadel
import NIOCore

import NIOSSH

class AllwaysGoodAuthDelegate:NIOSSHServerUserAuthenticationDelegate {
    var supportedAuthenticationMethods: NIOSSH.NIOSSHAvailableUserAuthenticationMethods
    = .all
    func requestReceived(request: NIOSSH.NIOSSHUserAuthenticationRequest,
                         responsePromise: NIOCore.EventLoopPromise<NIOSSH.NIOSSHUserAuthenticationOutcome>) {
        responsePromise.succeed(.success)
    }
    
    
}

class CentralDogma:ObservableObject {
    
    static let shared = CentralDogma()
    
    @Published var host:String = "localhost"
    
    /// Server to listen for ssh connections
    var server:SSHServer? = nil {
        didSet {
            debugPrint("initialized \(String(describing: server))")
        }
    }
    
    /// starts the server
    func startServer() async throws {
        server = try await SSHServer.host(
            host: host,
            port: 22,
            hostKeys: [
                // This hostkey changes every app boot, it's more practical to use a pre-generated one
                NIOSSHPrivateKey(ed25519Key: .init())
            ],
            authenticationDelegate: AllwaysGoodAuthDelegate()
        )
        
    }
    
    /// stops the server
    func stopServer() async throws {
        try await server?.close()
    }
    
    var client:SSHClient? {
        didSet {
            debugPrint("initalized \(client)")
        }
    }
    
    func startClient() async throws {
         client = try await SSHClient.connect(
            host: host,
            authenticationMethod: .passwordBased(username: "joannis", password: "s3cr3t"),
            hostKeyValidator: .acceptAnything(), // Please use another validator if at all possible, it's insecure
            reconnect: .never
        )
    }
    
    func stopClient() async throws {
        try await client?.close()
    }
}
