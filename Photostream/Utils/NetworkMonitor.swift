import Foundation
import Network

@MainActor
final class NetworkMonitor: ObservableObject {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published private(set) var isConnected = false
    @Published private(set) var connectionType = NWInterface.InterfaceType.other
    
    static let shared = NetworkMonitor()
    
    init() {
        monitor = NWPathMonitor()
        setupMonitor()
    }
    
    private func setupMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.availableInterfaces.first?.type ?? .other
            }
        }
        monitor.start(queue: queue)
    }
    
    func checkNetworkConnection() -> Bool {
        let hasConnection = isConnected
        let validInterface = connectionType == .cellular ||
        connectionType == .wifi ||
        connectionType == .wiredEthernet
        return hasConnection && validInterface
    }
    
    deinit {
        monitor.cancel()
    }
}
