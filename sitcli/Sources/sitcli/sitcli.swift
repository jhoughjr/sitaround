import Citadel
import NIOSSH
import NIO
import Foundation

struct Foo:ExecCommandContext {
    init() {
        print("Initialized Foo ExecCommandContext")
    }
    
    func terminate() async throws {
        print("Foo terminating")
    }
    
    func inputClosed() async throws {
        print("input closed")
    }
    
}

class AllwaysGoodAuthDelegate:NIOSSHServerUserAuthenticationDelegate {
    var supportedAuthenticationMethods: NIOSSH.NIOSSHAvailableUserAuthenticationMethods
    = .all
    func requestReceived(request: NIOSSH.NIOSSHUserAuthenticationRequest,
                         responsePromise: NIOCore.EventLoopPromise<NIOSSH.NIOSSHUserAuthenticationOutcome>) {
        print("someone knocking")
        responsePromise.succeed(.success)
    }
    
    
}

class Executor:ExecDelegate {
    init() {print("Executor init")}
    func start(command: String,
               outputHandler: Citadel.ExecOutputHandler) async throws -> Citadel.ExecCommandContext {
        print("starting command \(command)")
        outputHandler.succeed(exitCode: 0)
        return Foo()
    }
    
    func setEnvironmentValue(_ value: String, forKey key: String) async throws {
        
    }
    
    
}

/// We need to avoid blocking the main thread, so spin this off to a separate queue
 
@main
public class Sitcli {

    static let shared = Sitcli()
    static let runQueue = DispatchQueue(label: "Run")

    public private(set) var text = "Hello, World!"
    public private(set) var server:SSHServer? = nil
    {
        didSet {
            print("set server \(String(describing: server))")
        }
    }
    
    public private(set) var client:SSHClient? = nil {
        didSet {
            print("set client \(String(describing: client))")

        }
    }
    
    public static func main() async throws {
        print("main")
        try await Sitcli.shared.startServer()
        try await Sitcli.shared.startClient()
        try await Sitcli.shared.doSomething()
        try await Sitcli.shared.sitAndWait()
    }
    
    func sitAndWait() async throws {
        print("waiting, problably blocking")
        try await self.server?.closeFuture.get()
    }
    
    func doSomething() async throws {
        print("doing something...")
        let stdout = try await client?.executeCommand("ls -la ~")
        print("result: \(stdout)")
    }
    
    public func startServer() async throws{
        print("starting server")
            server = try? await SSHServer.host(
               host: "0.0.0.0",
               port: 22,
               hostKeys: [
                   // This hostkey changes every app boot, it's more practical to use a pre-generated one
                   NIOSSHPrivateKey(ed25519Key: .init())
               ],
               authenticationDelegate: AllwaysGoodAuthDelegate()
           )
           server?.enableExec(withDelegate: Executor())
    }

    public func startClient() async throws{
        print("starting client")
        client = try await SSHClient.connect(
            host: "localhost",
            authenticationMethod: .passwordBased(username: "joannis",
                                                 password: "s3cr3t"),
            hostKeyValidator: .acceptAnything(), // Please use another validator if at all possible, it's insecure
            reconnect: .never
        )
    }
}
