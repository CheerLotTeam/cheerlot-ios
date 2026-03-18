//
//  View+.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/18/26.
//

import SwiftUI

extension View {
    /// 커스텀 폰트 스타일(`TypeStyle`)을 한 줄로 적용하는 확장 메서드
    func font(_ style: TypeStyle) -> some View {
      self
        .font(style.font)
        .kerning(style.letterSpacingPx)
        .lineSpacing(style.extraSpacing)
        .padding(.vertical, style.extraSpacing / 2)
    }
}
