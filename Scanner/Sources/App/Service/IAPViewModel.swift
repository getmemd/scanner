//
//  PaywallViewModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import Foundation
import RevenueCat
import SwiftUI

final class IAPViewModel: ObservableObject {
    private var offerings: Offerings?
    
    @Published private(set) var error = ""
    @Published private(set) var isPurchasing = false
    @Published private(set) var isLoadingSubs = true
    
    @Published var showingSubview = false
    @Published var showAlert = false
    
    @AppStorage("subscriptionEndDate") private(set) var subscriptionEndDate = Date.now.timeIntervalSinceReferenceDate
    
    var isSubscribed: Bool {
        Date.now.timeIntervalSinceReferenceDate < subscriptionEndDate
    }
    
    init() {
        Task {
            await initialSetup()
        }
    }
    
    private func initialSetup() async {
        do {
            offerings = try await Purchases.shared.offerings()
            await self.checkStatus()
        } catch {
            print(error.localizedDescription)
        }
        await MainActor.run {
            isLoadingSubs = false
        }
    }
    
    func purchaseProduct(productType: ProductType) {
        isPurchasing = true
        Task {
            let package: Package? = offerings?.current?.availablePackages.first {
                $0.identifier == productType.packageID
            }
            if let package {
                do {
                    let result = try await Purchases.shared.purchase(package: package)
                    await MainActor.run {
                        updateSubscriptionStatus(from: result.customerInfo)
                    }
                    if result.userCancelled {
                        await MainActor.run {
                            showAlert = true
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Zero products available")
            }
            await MainActor.run {
                isPurchasing = false
            }
        }
    }
    
    func restore() async {
        do {
            let result = try await Purchases.shared.restorePurchases()
            await MainActor.run {
                updateSubscriptionStatus(from: result)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkStatus() async {
        do {
            let result = try await Purchases.shared.customerInfo()
            await MainActor.run {
                updateSubscriptionStatus(from: result)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func updateSubscriptionStatus(from result: CustomerInfo) {
        if let expiresAt = result.entitlements.active.first?.value.expirationDate {
            subscriptionEndDate = expiresAt.timeIntervalSinceReferenceDate
        } else {
            subscriptionEndDate = Date.now.timeIntervalSinceReferenceDate
        }
    }
}
