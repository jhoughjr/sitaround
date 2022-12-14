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
import NIO

class SDelegate:CitadelServerDelegate {
    
}
class CentralDogma:ObservableObject {

    private let group: NIO.MultiThreadedEventLoopGroup!
    var serverChannel:Channel?
    let logger = Logger.shared
    
    static let shared = CentralDogma()
    
    init() {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        server = SSHServer(channel: serverChannel,
                           logger: logger,
                           delegate: CitadelServerDelegate)
    }
    
    @Published var host:String = "localhost"
    
    /// Server to listen for ssh connections
    var server:SSHServer? = nil {
        didSet {
            debugPrint("initialized \(String(describing: server))")
        }
    }
    
    /// starts the server
    func startServer() async throws {
        debugPrint("starting server")
       
    }
    
    /// stops the server
    func stopServer() async throws {

    }
    
    var client:SSHClient? {
        didSet {
            debugPrint("initalized \(String(describing: client))")
        }
    }
    
    func startClient() async throws {
        
        
    }
    
    func stopClient() async throws {

    }
}
