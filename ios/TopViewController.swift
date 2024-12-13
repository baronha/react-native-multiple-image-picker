//
//  TopViewController.swift
//  Pods
//
//  Created by BAO HA on 11/12/24.
//

import UIKit

func getTopViewController() -> UIViewController? {
    var controller = UIApplication.shared.keyWindow?.rootViewController
    while let presentedViewController = controller?.presentedViewController {
        controller = presentedViewController
    }

    return controller
}
