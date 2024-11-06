//
//  ScannerViewModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import Foundation
import LanScanner

final class ScannerViewModel: ObservableObject {
    @Published var connectedDevices = [Device<LanDeviceModel>]()
    @Published var isScanning: Bool = false
    private lazy var scanner = LanScanner(delegate: self)
    
    func reload() {
        isScanning = true
        connectedDevices.removeAll()
        scanner.start()
    }
    
    func stopScan() {
        isScanning = false
        scanner.stop()
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

// MARK: - LanScannerDelegate

extension ScannerViewModel: LanScannerDelegate {
    func lanScanHasUpdatedProgress(_ progress: CGFloat, address: String) { }
    
    func lanScanDidFindNewDevice(_ device: LanDevice) {
        connectedDevices.append(Device(device: LanDeviceModel(from: device), isSecure: true))
    }
    
    func lanScanDidFinishScanning() {
        isScanning = false
    }
}
