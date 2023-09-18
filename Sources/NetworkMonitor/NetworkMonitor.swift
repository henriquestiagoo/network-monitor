import Foundation
import Network

/// adding NotificationCenter support
extension Notification.Name {
    public static let connectivityStatusChanged = Notification.Name("connectivityStatusChanged")
}

/// add conformance to CaseInterable Protocol
extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

public final class NetworkMonitor {
    public static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")

    /// the NWPathMonitor is an observer that we can use to monitor and react to network changes.
    private let monitor: NWPathMonitor

    public var isConnected = false

    /// Checks if the path uses an NWInterface that is considered to
    /// be expensive
    ///
    /// Cellular interfaces are considered expensive. WiFi hotspots
    /// from an iOS device are considered expensive. Other
    /// interfaces may appear as expensive in the future.
    public var isExpensive = false

    /// Interface types represent the underlying media for
    /// a network link
    ///
    /// This can either be `other`, `wifi`, `cellular`,
    /// `wiredEthernet`, or `loopback`
    public var currentConnectionType: NWInterface.InterfaceType?

    private init() {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive

            // identifies the current conneection type from the list of potential network link types
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first

            // post connectivity changed notification
            NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil)
        }
        monitor.start(queue: queue)
    }

    public func stopMonitoring() {
        monitor.cancel()
    }
}
