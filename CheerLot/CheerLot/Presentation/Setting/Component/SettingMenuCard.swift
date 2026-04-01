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

  private var cardCornerRadius: CGFloat {
    titles.count == 1 ? 25 : 20
  }

  var body: some View {
    VStack(spacing: .zero) {
      ForEach(titles.indices, id: \.self) { idx in
        Button {
          onTap(idx)
        } label: {
          HStack {
            Text(titles[idx])
              .font(.M3)
              .foregroundStyle(.gray800)

            Spacer()

            Image(systemName: "chevron.right")
              .font(.system(size: 16, weight: .medium))
              .foregroundStyle(.gray100)
          }
          .padding(.vertical, 14)
          .padding(.horizontal, 5)
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        if idx != titles.count - 1 {
          Rectangle()
            .fill(.gray100)
            .frame(height: 0.25)
        }
      }
    }
    .padding(.horizontal, 19)
    .padding(.vertical, 6)
    .background(
      RoundedRectangle(cornerRadius: cardCornerRadius)
        .fill(.gray000)
    )
    .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
  }
}
