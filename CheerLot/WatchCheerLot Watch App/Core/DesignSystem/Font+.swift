//
//  Font+.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/18/26.
//

import Foundation
import SwiftUI

// MARK: - TypeStyle
public struct TypeStyle {
  public let font: Font  // SwiftUI 폰트 (Pretendard)
  public let size: CGFloat  // 폰트 사이즈
  public let lineHeight: CGFloat  // 기준 배수 (ex. 1.5)
  public let letterSpacing: CGFloat  // 퍼센트 (-0.02 = -2%)

  public init(
    font: Font,
    size: CGFloat,
    lineHeight: CGFloat,
    letterSpacing: CGFloat
  ) {
    self.font = font
    self.size = size
    self.lineHeight = lineHeight
    self.letterSpacing = letterSpacing
  }

  /// 실제 pt 기반 보정값 계산
  public var extraSpacing: CGFloat {
    max((size * lineHeight) - size, 0)
  }

  /// 자간 변환
  public var letterSpacingPx: CGFloat {
    letterSpacing * size
  }
}

extension Font {
  public enum Pretendard: String {
    case semibold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"

    /// SwiftUI 폰트 반환
    func swiftUIFont(size: CGFloat) -> Font {
      .custom(rawValue, fixedSize: size)
    }
  }
}

// MARK: - Style Presets
/// WatchOS 프로젝트 전역에서 사용 가능한 텍스트 스타일 프리셋 모음
extension TypeStyle {
  /// SemiBold 18pt
  public static let SB6 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 18),
    size: 18,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 16pt
  public static let SB7 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 16),
    size: 16,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  /// Medium 10pt
  public static let M6 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 10),
    size: 10,
    lineHeight: 1.2,
    letterSpacing: 0
  )

  /// Regular 12pt
  public static let R3 = TypeStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 12),
    size: 12,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Lyrics Typo
  public static let LyricsTypo = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 22),
    size: 22,
    lineHeight: 1.5,
    letterSpacing: 0
  )
}
