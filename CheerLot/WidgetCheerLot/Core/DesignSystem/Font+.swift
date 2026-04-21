//
//  Font+.swift
//  WidgetCheerLotExtension
//
//  Created by 이승진 on 4/2/26.
//

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
  public enum RobotoCondensed: String {
    case black = "RobotoCondensed-Black"
    case medium = "RobotoCondensed-Medium"

    /// SwiftUI 폰트 반환
    func swiftUIFont(size: CGFloat) -> Font {
      .custom(rawValue, fixedSize: size)
    }
  }

  public enum Pretendard: String {
    case bold = "Pretendard-Bold"
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
/// 위젯 프로젝트 전역에서 사용 가능한 텍스트 스타일 프리셋 모음
extension TypeStyle {

  /// Black 15pt
  public static let T4 = TypeStyle(
    font: Font.RobotoCondensed.black.swiftUIFont(size: 15),
    size: 15,
    lineHeight: 1.0,
    letterSpacing: 0
  )

  /// Medium 15pt
  public static let T5 = TypeStyle(
    font: Font.RobotoCondensed.medium.swiftUIFont(size: 15),
    size: 15,
    lineHeight: 1.0,
    letterSpacing: 0
  )

  /// Bold 28pt
  public static let B1 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Bold 24pt
  public static let B3 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 24pt
  public static let SB3 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 20pt
  public static let SB5 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 20),
    size: 20,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 14pt
  public static let SB8 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 14),
    size: 14,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 12pt
  public static let SB9 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 12),
    size: 12,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Medium 12pt
  public static let M5 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 12),
    size: 12,
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

  /// Medium 8pt
  public static let M7 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 8),
    size: 8,
    lineHeight: 1.2,
    letterSpacing: 0
  )
}
