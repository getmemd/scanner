//
//  ScannerViewModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import Foundation

final class ScannerViewModel: NSObject, ObservableObject {
    @Published var connectedDevices = [Device]()
    @Published var scanProgress: Float = 0.0
    @Published var isScanning: Bool = false
    @Published var isNavigatingToResults = false
    private lazy var scanner = LanScan(delegate: self)
    
    func reload() {
        isScanning = true
        connectedDevices.removeAll()
        scanner?.start()
    }
    
    func stopScan() {
        isScanning = false
        scanner?.stop()
    }
    
    func getIpAddress() -> String? {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                } else if (name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3") {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(1), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}

// MARK: - LANScanDelegate

extension ScannerViewModel: LANScanDelegate {
    func lanScanHasUpdatedProgress(_ counter: Int, address: String!) {
        scanProgress = Float(counter) / Float(MAX_IP_RANGE)
    }
    
    func lanScanDidFindNewDevice(_ device: [AnyHashable : Any]!) {
        guard let device = device as? [AnyHashable : String] else { return }
        connectedDevices.append(Device(data: device))
    }
    
    func lanScanDidFinishScanning() {
        StorageService.shared.checkSecure(devices: &connectedDevices)
        isScanning = false
        isNavigatingToResults = true
    }
}
