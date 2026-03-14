//
//  CustomToastMessageView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct CustomToastMessageView: View {
  let message: String
  var showCaution: Bool = true
  @Binding var isPresented: Bool

  var body: some View {
    HStack(spacing: 8) {
      if showCaution {
        Image(.caution)
          .resizable()
          .scaledToFit()
          .frame(width: 18)
      }

      Text(message)
        .font(.M3)
        .foregroundStyle(.grayWhite)
    }
    .padding(.horizontal, 39.5)
    .padding(.vertical, 13.5)
    .background(
      RoundedRectangle(cornerRadius: 24)
        .fill(Color.black.opacity(0.8))
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    .padding(.bottom, UIScreen.height * 0.12)
    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
    .zIndex(999)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
        withAnimation {
          isPresented = false
        }
      }
    }
  }
}

#Preview {
  CustomToastMessageView(
    message: "아직 개인 응원가가 없어요",
    showCaution: true,
    isPresented: .constant(true)
  )
}
