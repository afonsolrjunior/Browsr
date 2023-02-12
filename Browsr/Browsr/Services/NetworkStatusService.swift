//
//  NetworkStatusService.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine
import Network

enum NetworkStatus {
    case connected
    case disconnected
}

protocol NetworkStatusService {
    func getStatus() -> AnyPublisher<NetworkStatus, Never>
}

final class NetworkStatusMonitor: NetworkStatusService {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    private let publisher = PassthroughSubject<NetworkStatus, Never>()
    
    func getStatus() -> AnyPublisher<NetworkStatus, Never> {
        monitor.pathUpdateHandler = {[weak self] path in
            guard let self else { return }
            self.publisher.send(path.status == .satisfied ? .connected : .disconnected)
        }
        monitor.start(queue: queue)
        return publisher.eraseToAnyPublisher()
    }
    
}


