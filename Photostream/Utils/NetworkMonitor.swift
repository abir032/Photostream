import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitor")
    @Published private var isConnected = false

    init() {
        checkConnection()
    }

    private func checkConnection() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }

    func checkNetworkBeforeAPI() -> Bool {
        if isConnected {
            return true
        } else {
            return false
        }
    }
    deinit {
        networkMonitor.cancel()
    }
}
