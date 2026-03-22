//
//  Font+.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import Foundation
import SwiftUI
import UIKit

extension Font {
  enum Pretend {
    case extraBold
    case bold
    case semibold
    case medium
    case regular
    case light

    var value: String {
      switch self {
      case .extraBold:
        return "Pretendard-ExtraBold"
      case .bold:
        return "Pretendard-Bold"
      case .semibold:
        return "Pretendard-SemiBold"
      case .medium:
        return "Pretendard-Medium"
      case .regular:
        return "Pretendard-Regular"
      case .light:
        return "Pretendard-Light"
      }
    }
  }

  static func pretend(type: Pretend, size: CGFloat) -> Font {
    return .custom(type.value, size: size)
  }

  // 동적 pretend
  static func dynamicPretend(type: Pretend, size: CGFloat) -> Font {
    let scaledSize = DynamicLayout.dynamicValuebyWidth(size)
    return .custom(type.value, size: scaledSize)
  }

  static func freshman(size: CGFloat) -> Font {
    return .custom("Freshman", size: size)
  }

  // 동적 freshman
  static func dynamicFreshman(size: CGFloat) -> Font {
    let scaledSize = DynamicLayout.dynamicValuebyWidth(size)
    return .custom("Freshman", size: scaledSize)
  }
}

// MARK: - TypeStyle

/// 커스텀 텍스트 스타일
///
/// `Font`(SwiftUI) + `UIFont`(UIKit)를 함께 관리하면서,
/// 줄간격(lineHeight), 자간(letterSpacing)을 실제 pt 단위로 자동 계산해 적용합니다.
///
/// - Note:
///   - `lineHeight`: Figma 기준 배수 (예: 1.5 = 150%)
///   - `letterSpacing`: 폰트 크기에 대한 비율 (-0.02 = -2%)
///   - `extraSpacing`: 실제 라인 간격(pt)
///
/// 사용 예시:
/// ```swift
/// Text("제목")
///   .font(.H1)
/// ```
public struct TypeStyle {
  public let font: Font  // SwiftUI 폰트 (Pretendard)
  public let uiFont: UIFont  // 실제 UIKit 폰트
  public let size: CGFloat  // 폰트 사이즈
  public let lineHeight: CGFloat  // 기준 배수 (ex. 1.5)
  public let letterSpacing: CGFloat  // 퍼센트 (-0.02 = -2%)

  public init(
    font: Font,
    uiFont: UIFont,
    size: CGFloat,
    lineHeight: CGFloat,
    letterSpacing: CGFloat
  ) {
    self.font = font
    self.uiFont = uiFont
    self.size = size
    self.lineHeight = lineHeight
    self.letterSpacing = letterSpacing
  }

  /// 실제 pt 기반 보정값 계산
  public var extraSpacing: CGFloat {
    max((size * lineHeight) - uiFont.lineHeight, 0)
  }

  /// 실제 pt 단위 자간 변환
  public var letterSpacingPx: CGFloat {
    letterSpacing * size
  }
}

// MARK: - Font 연결
/// 커스텀 폰트를 프로젝트 디자인 시스템에서 사용하는 Enum
///
/// SwiftUI / UIKit 폰트를 동일한 value 기준으로 생성하여
/// lineHeight 등 메트릭 계산의 일관성을 유지
///
/// - Example:
/// ```swift
/// Font.Pretendard.semibold.swiftUIFont(size: 20)
/// Font.Pretendard.semibold.uiFont(size: 20)
/// ```
extension Font {
  public enum RobotoCondensed: String {
    case black = "RobotoCondensed-Black"

    /// UIKit 폰트 반환
    func uiFont(size: CGFloat) -> UIFont {
      UIFont(name: rawValue, size: size)
        ?? .systemFont(ofSize: size)
    }

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

    /// UIKit 폰트 반환
    func uiFont(size: CGFloat) -> UIFont {
      UIFont(name: rawValue, size: size)
        ?? .systemFont(ofSize: size)
    }

    /// SwiftUI 폰트 반환
    func swiftUIFont(size: CGFloat) -> Font {
      .custom(rawValue, fixedSize: size)
    }
  }
}

// MARK: - Style Presets
/// 프로젝트 전역에서 사용 가능한 텍스트 스타일 프리셋 모음
extension TypeStyle {

  // MARK: - RobotoCondensed
  /// Black 38pt
  public static let T1 = TypeStyle(
    font: Font.RobotoCondensed.black.swiftUIFont(size: 38),
    uiFont: Font.RobotoCondensed.black.uiFont(size: 38),
    size: 38,
    lineHeight: 1.0,
    letterSpacing: 0
  )

  /// Black 30pt
  public static let T2 = TypeStyle(
    font: Font.RobotoCondensed.black.swiftUIFont(size: 30),
    uiFont: Font.RobotoCondensed.black.uiFont(size: 30),
    size: 30,
    lineHeight: 1.0,
    letterSpacing: 0
  )

  /// Black 24pt
  public static let T3 = TypeStyle(
    font: Font.RobotoCondensed.black.swiftUIFont(size: 24),
    uiFont: Font.RobotoCondensed.black.uiFont(size: 24),
    size: 24,
    lineHeight: 0.9,
    letterSpacing: 0
  )

  // MARK: - Pretendard
  /// Bold 28pt, lineHeight 1.3%
  public static let B1 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 28),
    uiFont: Font.Pretendard.bold.uiFont(size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Bold 28pt,  lineHeight 1.6%
  public static let B1_1 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 28),
    uiFont: Font.Pretendard.bold.uiFont(size: 28),
    size: 28,
    lineHeight: 1.6,
    letterSpacing: -0.04
  )

  /// Bold 26pt
  public static let B2 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 26),
    uiFont: Font.Pretendard.bold.uiFont(size: 26),
    size: 26,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Bold 24pt
  public static let B3 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 24),
    uiFont: Font.Pretendard.bold.uiFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Bold 12pt
  public static let B4 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 12),
    uiFont: Font.Pretendard.bold.uiFont(size: 12),
    size: 12,
    lineHeight: 1.2,
    letterSpacing: 0
  )

  /// SemiBold 48pt
  public static let SB1 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 48),
    uiFont: Font.Pretendard.semibold.uiFont(size: 48),
    size: 48,
    lineHeight: 1.0,
    letterSpacing: 0
  )

  /// SemiBold 32pt
  public static let SB2 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 32),
    uiFont: Font.Pretendard.semibold.uiFont(size: 32),
    size: 32,
    lineHeight: 1.5,
    letterSpacing: 0
  )

  /// SemiBold 24pt
  public static let SB3 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 24),
    uiFont: Font.Pretendard.semibold.uiFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 22pt
  public static let SB4 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 22),
    uiFont: Font.Pretendard.semibold.uiFont(size: 22),
    size: 22,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 20pt
  public static let SB5 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 20),
    uiFont: Font.Pretendard.semibold.uiFont(size: 20),
    size: 20,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 20pt_lineupName
  public static let SB5_lineupName = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 20),
    uiFont: Font.Pretendard.semibold.uiFont(size: 20),
    size: 20,
    lineHeight: 1.0,
    letterSpacing: 0
  )

  /// SemiBold 18pt
  public static let SB6 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 18),
    uiFont: Font.Pretendard.semibold.uiFont(size: 18),
    size: 18,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 16pt
  public static let SB7 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 16),
    uiFont: Font.Pretendard.semibold.uiFont(size: 16),
    size: 16,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 14pt
  public static let SB8 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 14),
    uiFont: Font.Pretendard.semibold.uiFont(size: 14),
    size: 14,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 12pt
  public static let SB9 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 12),
    uiFont: Font.Pretendard.semibold.uiFont(size: 12),
    size: 12,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// SemiBold 10pt
  public static let SB10 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 10),
    uiFont: Font.Pretendard.semibold.uiFont(size: 10),
    size: 10,
    lineHeight: 1.2,
    letterSpacing: 0
  )

  /// Medium 28pt
  public static let M0 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 28),
    uiFont: Font.Pretendard.medium.uiFont(size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: 0
  )

  /// Medium 20pt
  public static let M1 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 20),
    uiFont: Font.Pretendard.medium.uiFont(size: 20),
    size: 20,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Medium 18pt
  public static let M2 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 18),
    uiFont: Font.Pretendard.medium.uiFont(size: 18),
    size: 18,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Medium 16pt
  public static let M3 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 16),
    uiFont: Font.Pretendard.medium.uiFont(size: 16),
    size: 16,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Medium 14pt
  public static let M4 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 14),
    uiFont: Font.Pretendard.medium.uiFont(size: 14),
    size: 14,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Medium 12pt
  public static let M5 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 12),
    uiFont: Font.Pretendard.medium.uiFont(size: 12),
    size: 12,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Medium 12pt_Game State
  public static let M5_gameState = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 12),
    uiFont: Font.Pretendard.medium.uiFont(size: 12),
    size: 12,
    lineHeight: 1.2,
    letterSpacing: 0
  )

  /// Medium 12pt_position
  public static let M5_position = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 12),
    uiFont: Font.Pretendard.medium.uiFont(size: 12),
    size: 12,
    lineHeight: 1.0,
    letterSpacing: -0.05
  )

  /// Medium 10pt
  public static let M6 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 10),
    uiFont: Font.Pretendard.medium.uiFont(size: 10),
    size: 10,
    lineHeight: 1.2,
    letterSpacing: 0
  )

  /// Regular 16pt
  public static let R1 = TypeStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 16),
    uiFont: Font.Pretendard.regular.uiFont(size: 16),
    size: 16,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Regular 14pt
  public static let R2 = TypeStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 14),
    uiFont: Font.Pretendard.regular.uiFont(size: 14),
    size: 14,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  /// Regular 12pt
  public static let R3 = TypeStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 12),
    uiFont: Font.Pretendard.regular.uiFont(size: 12),
    size: 12,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
}
