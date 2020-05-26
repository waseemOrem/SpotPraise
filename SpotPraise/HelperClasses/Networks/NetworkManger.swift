//
//  NetworkManger.swift
//  Firla
//
//  Created by admin on 28/02/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import Network
import SystemConfiguration

class MonitorNetwork{
    
    static let networkConnection = MonitorNetwork()
    /// Dispatch queue
    private var queue = DispatchQueue(label: "Monitor", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    /// Network connection monitor. It will automatically notify when ever you connection was update.
    ///
    /// - Parameter isConnected: isConnected to internet or not.
    func networkMonitor(isConnected: @escaping((_ state: Bool,_ interfare: String?) -> ())) {
        
        if #available(iOS 12.0, *) {
            let pathMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
            
            pathMonitor.pathUpdateHandler = { path in
                
                if path.status == NWPath.Status.satisfied {
                    pathMonitor.cancel()
                    // pathMonitor = nil
                    if path.usesInterfaceType(.wifi) {
                        isConnected(true, "WiFi")
                    } else if path.usesInterfaceType(.cellular) {
                        isConnected(true, "cellular")
                    } else if path.usesInterfaceType(.wiredEthernet) {
                        isConnected(true, "wiredEthernet")
                    } else {
                        isConnected(true, "others")
                    }
                } else {
                    pathMonitor.cancel()
                    isConnected(false, nil)
                }
                print("is Cellular data: \(path.isExpensive)") //Checking is this is a Cellular data
            }
            pathMonitor.start(queue: queue)
            
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    
}

