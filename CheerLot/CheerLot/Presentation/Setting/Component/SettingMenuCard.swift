//
//  SettingMenuCard.swift
//  CheerLot
//
//  Created by 이승진 on 3/3/26.
//

import SwiftUI

struct SettingsMenuCard: View {
  let titles: [String]
  let onTap: (Int) -> Void

  var body: some View {
    VStack(spacing: .zero) {
      ForEach(titles.indices, id: \.self) { idx in
        Button { onTap(idx) } label: {
          HStack {
            Text(titles[idx])
              .font(.M3)
              .foregroundStyle(.gray800)

            Spacer()

            Image(systemName: "chevron.right")
              .resizable()
              .scaledToFit()
              .frame(width: 8, height: 14)
              .foregroundStyle(.gray200)
          }
          .padding(.vertical, 14)
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        if idx != titles.count - 1 {
          Rectangle()
            .fill(.gray200)
            .frame(height: 0.5)
        }
      }
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 6)
    .background(RoundedRectangle(cornerRadius: 20).fill(.gray100))
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}
