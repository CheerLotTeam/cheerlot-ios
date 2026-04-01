//
//  CustomToastModifier.swift
//  CheerLot
//
//  Created by 이현주 on 3/17/26.
//

import SwiftUI

struct CustomToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  let message: String
  var showCaution: Bool = true
  let bottomPadding: CGFloat

  func body(content: Content) -> some View {
    ZStack {
      content

      if isPresented {
        CustomToastMessageView(
          message: message,
          showCaution: showCaution,
          bottomPadding: bottomPadding,
          isPresented: $isPresented
        )
      }
    }
    .animation(.easeInOut(duration: 0.3), value: isPresented)
  }
}
