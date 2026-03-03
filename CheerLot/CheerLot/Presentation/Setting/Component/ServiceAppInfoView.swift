//
//  ServiceAppInfoView.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 서비스 약관 (이용약관, 개인정보처리방침, 저작권 법적고지)에서 쓰이는 공통 화면입니다.
struct ServiceAppInfoView: View {

  let title: String
  let text: String

  var body: some View {
    VStack(spacing: 20) {
      ScrollView {
        Text(text)
          .font(.R2)
          .foregroundStyle(.gray500)
      }
    }
    .navigationBarBackButtonHidden(true)
    .navigationBar_backWithTitle(title: title) {

    }
  }
}

#Preview {
  ServiceAppInfoView(title: "이용약관", text: "")
}
