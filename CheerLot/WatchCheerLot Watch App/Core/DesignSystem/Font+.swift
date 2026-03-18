//
//  Font+.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/18/26.
//

import Foundation
import SwiftUI
import UIKit

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
  public enum Pretendard: String {
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
      .custom(rawValue, size: size)
    }
  }
}

// MARK: - Style Presets
/// 프로젝트 전역에서 사용 가능한 텍스트 스타일 프리셋 모음
extension TypeStyle {
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
  /// Medium 10pt
  public static let M6 = TypeStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 10),
    uiFont: Font.Pretendard.medium.uiFont(size: 10),
    size: 10,
    lineHeight: 1.2,
    letterSpacing: 0
  )

  /// Regular 12pt
  public static let R3 = TypeStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 12),
    uiFont: Font.Pretendard.regular.uiFont(size: 12),
    size: 12,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
    
  /// Lyrics Typo
  public static let LyricsTypo = TypeStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 22),
    uiFont: Font.Pretendard.semibold.swiftUIFont(size: 22),
    size: 22,
    lineHeight: 1.5,
    letterSpacing: 0
  )
}
