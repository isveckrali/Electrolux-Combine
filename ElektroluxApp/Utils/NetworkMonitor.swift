//
//  NetworkMonitor.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    
    //MARK: - PROPERTIES
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    //MARK: - FONCTIONS
    init() {
        startMonitor()
    }
    
    //Monitor internet connection if it changes
    private func startMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}
