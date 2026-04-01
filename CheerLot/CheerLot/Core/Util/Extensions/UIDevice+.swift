//
//  UIDevice+.swift
//  CheerLot
//
//  Created by 이현주 on 7/9/25.
//

import Foundation
import UIKit

extension UIDevice {
  static var isIOS26OrLater: Bool {
    if #available(iOS 26, *) { return true }
    return false
  }
}
