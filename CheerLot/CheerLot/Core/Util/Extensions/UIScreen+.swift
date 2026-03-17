//
//  UIScreen+.swift
//  CheerLot
//
//  Created by 이현주 on 3/14/26.
//

import UIKit

extension UIScreen {
  static var current: CGRect {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    return window?.screen.bounds ?? .zero
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
