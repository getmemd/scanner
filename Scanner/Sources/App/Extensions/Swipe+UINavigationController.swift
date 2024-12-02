//
//  Swipe+UINavigationController.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 02.12.2024.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
