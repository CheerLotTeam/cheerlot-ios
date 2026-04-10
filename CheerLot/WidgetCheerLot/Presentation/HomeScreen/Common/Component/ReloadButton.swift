//
//  ReloadButton.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import AppIntents
import SwiftUI

struct ReloadButton: View {
  let color: Color

  var body: some View {
    Button(intent: RefreshGameInfoIntent()) {
      Image(systemName: "arrow.clockwise")
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(color)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  ReloadButton(color: .gray)
}
