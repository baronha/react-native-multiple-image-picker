//
//  UIColor+React.swift
//  Pods
//
//  Created by BAO HA on 16/10/24.
//

import React
import UIKit

func getReactColor(_ color: Int?) -> UIColor? {
    RCTConvert.uiColor(color)
}
