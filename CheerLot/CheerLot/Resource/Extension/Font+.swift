//
//  Font+.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import Foundation
import SwiftUI

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

import UIKit
import SwiftUI

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
  public let font: Font             // SwiftUI 폰트 (Pretendard)
  public let uiFont: UIFont         // 실제 UIKit 폰트
  public let size: CGFloat          // 폰트 사이즈
  public let lineHeight: CGFloat    // 기준 배수 (ex. 1.5)
  public let letterSpacing: CGFloat // 퍼센트 (-0.02 = -2%)
  
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
public extension Font {
  enum SUITE {
    case heavy
    case extrabold
    case bold
    
    var value: String {
      switch self {
      case .heavy:
        return "SUITE-Heavy"
      case .extrabold:
        return "SUITE-ExtraBold"
      case .bold:
        return "SUITE-Bold"
      }
    }
    
    /// UIKit 폰트 반환
    func uiFont(size: CGFloat) -> UIFont {
      UIFont(name: value, size: size)
      ?? UIFont.systemFont(ofSize: size)
    }
    
    /// SwiftUI 폰트 반환
    func swiftUIFont(size: CGFloat) -> Font {
      Font.custom(value, size: size)
    }
  }
  
  enum Pretendard {
    case bold
    case semibold
    case medium
    case regular
    
    var value: String {
      switch self {
      case .bold:
        return "Pretendard-Bold"
      case .semibold:
        return "Pretendard-SemiBold"
      case .medium:
        return "Pretendard-Medium"
      case .regular:
        return "Pretendard-Regular"
      }
    }
    
    /// UIKit 폰트 반환
    func uiFont(size: CGFloat) -> UIFont {
      UIFont(name: value, size: size)
        ?? UIFont.systemFont(ofSize: size)
    }
    
    /// SwiftUI 폰트 반환
    func swiftUIFont(size: CGFloat) -> Font {
      Font.custom(value, size: size)
    }
  }
}

// MARK: - View Extension
/// 커스텀 폰트 스타일(`TypeStyle`)을 한 줄로 적용하는 확장 메서드
///
/// - Example:
/// ```swift
/// Text("본문 텍스트")
///   .font(.B1_M)
/// ```
public extension View {
  func font(_ style: TypeStyle) -> some View {
    self
      .font(style.font)
      .kerning(style.letterSpacingPx)
      .lineSpacing(style.extraSpacing)
      .padding(.vertical, style.extraSpacing / 2)
  }
}

// MARK: - Style Presets
/// 프로젝트 전역에서 사용 가능한 텍스트 스타일 프리셋 모음
public extension TypeStyle {
  // MARK: - SUITE
  /// Heavy 32pt
  static let H1 = TypeStyle(
    font: Font.SUITE.heavy.swiftUIFont(size: 32),
    uiFont: Font.SUITE.heavy.uiFont(size: 32),
    size: 32,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Heavy 30pt
  static let H2 = TypeStyle(
    font: Font.SUITE.heavy.swiftUIFont(size: 30),
    uiFont: Font.SUITE.heavy.uiFont(size: 30),
    size: 30,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// ExtraBold 30pt
  static let T1 = TypeStyle(
    font: Font.SUITE.extrabold.swiftUIFont(size: 30),
    uiFont: Font.SUITE.extrabold.uiFont(size: 30),
    size: 30,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// ExtraBold 28pt
  static let T2 = TypeStyle(
    font: Font.SUITE.extrabold.swiftUIFont(size: 28),
    uiFont: Font.SUITE.extrabold.uiFont(size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// ExtraBold 26pt
  static let T3 = TypeStyle(
    font: Font.SUITE.extrabold.swiftUIFont(size: 26),
    uiFont: Font.SUITE.extrabold.uiFont(size: 26),
    size: 26,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Bold 24pt
  static let T4 = TypeStyle(
    font: Font.SUITE.bold.swiftUIFont(size: 24),
    uiFont: Font.SUITE.bold.uiFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  // MARK: - Pretendard
  /// Bold 28pt
  static let B1 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 28),
    uiFont: Font.Pretendard.bold.uiFont(size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Bold 26pt
  static let B2 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 26),
    uiFont: Font.Pretendard.bold.uiFont(size: 26),
    size: 26,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Bold 24pt
  static let B3 = TypeStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 24),
    uiFont: Font.Pretendard.bold.uiFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// SemiBold 24pt
  static let SB1 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 24),
    uiFont: Font.Pretendard.semibold.uiFont(size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// SemiBold 22pt
  static let SB2 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 22),
    uiFont: Font.Pretendard.semibold.uiFont(size: 22),
    size: 22,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// SemiBold 20pt
  static let SB3 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 20),
    uiFont: Font.Pretendard.semibold.uiFont(size: 20),
    size: 20,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// SemiBold 18pt
  static let SB4 = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 18),
    uiFont: Font.Pretendard.semibold.uiFont(size: 18),
    size: 18,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Medium 20pt
  static let M1 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 20),
    uiFont: Font.Pretendard.medium.uiFont(size: 20),
    size: 20,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Medium 18pt
  static let M2 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 18),
    uiFont: Font.Pretendard.medium.uiFont(size: 18),
    size: 18,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Medium 16pt
  static let M3 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 16),
    uiFont: Font.Pretendard.medium.uiFont(size: 16),
    size: 16,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Regular 16pt
  static let R1 = TypeStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 16),
    uiFont: Font.Pretendard.regular.uiFont(size: 16),
    size: 16,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Regular 14pt
  static let R2 = TypeStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 14),
    uiFont: Font.Pretendard.regular.uiFont(size: 14),
    size: 14,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
}
