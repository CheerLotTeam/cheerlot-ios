//
//  UIScreen+.swift
//  CheerLot
//
//  Created by 이현주 on 3/14/26.
//

import UIKit

@MainActor
extension UIScreen {
  static var current: CGRect {
    let activeScene = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }

    let keyWindow = activeScene?.windows.first(where: \.isKeyWindow)
    return keyWindow?.screen.bounds ?? UIScreen.main.bounds
  }

  /// 화면 너비
  static var width: CGFloat {
    current.width
  }

  /// 화면 높이
  static var height: CGFloat {
    current.height
  }

  /// 화면 크기
  static var size: CGSize {
    current.size
  }
}
