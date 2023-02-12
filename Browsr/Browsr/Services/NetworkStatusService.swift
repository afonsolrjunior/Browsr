//
//  NetworkStatusService.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine
import Network

enum NetworkError: Error {
    case disconnected
}

enum NetworkStatus {
    case connected
    case disconnected
}

protocol NetworkStatusService {
    func startMonitoring()
    func stopMonitoring()
    func getStatus() -> NetworkStatus
}

final class NetworkStatusMonitor: NetworkStatusService {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    private var status: NetworkStatus = .disconnected
    
    init() {
        monitor.pathUpdateHandler = {[weak self] path in
            guard let self else { return }
            self.status = path.status == .satisfied ? .connected : .disconnected
        }
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func getStatus() -> NetworkStatus {
        return status
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
}


