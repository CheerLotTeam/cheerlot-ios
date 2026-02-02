//
//  PlayBtn.swift
//  CheerLot
//
//  Created by 이승진 on 2/2/26.
//

import SwiftUI

/// 전체 선수 화면의 전체 재생 버튼입니다.
struct PlayBtn: View {
  
  // MARK: - Properties
  let action: () -> Void
  let theme: Theme
  
  // MARK: - Body
  var body: some View {
    Button {
      action()
    } label: {
      HStack(spacing: 4) {
        Text("전체 재생")
          .font(.M5)
          .foregroundColor(.grayWhite)
        
        Image(.musicNote)
          .resizable()
          .frame(width: 15, height: 14)
          .foregroundStyle(.grayWhite)
      }
      .frame(height: 30)
      .padding(1)
      .padding(.horizontal, 10)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .foregroundStyle(theme.primaryColor)
      )
    }
  }
}

#Preview {
  PlayBtn(action: { print("전체 재생 버튼입니다") }, theme: .SS)
}
