//
//  MiniPlayerView.swift
//  CheerLot
//
//  Created by 이승진 on 2/11/26.
//

import SwiftUI

/// MainTabView에 종속되는 미니플레이어입니다.
struct MiniPlayerView: View {

  // MARK: - Properties
  let coverImage: Image
  let playerName: String
  let title: String
  let isPlaying: Bool

  let onTap: () -> Void
  let onPlayPause: () -> Void
  let onNext: () -> Void

  private let layout = MiniPlayerLayout.current

  // MARK: - Body
  var body: some View {
    HStack {
      cheerSongInfo
      Spacer()
      controlContents
    }
    .padding(.leading, layout.leadingSpacing)
    .padding(.trailing, layout.trailingSpacing)
    .padding(.vertical, 8)
    .frame(height: layout.height)
    .background(backgroundView)
    .contentShape(Rectangle())
    .onTapGesture(perform: onTap)
  }
}

extension MiniPlayerView {
  /// iOS 버전별 배경
  @ViewBuilder
  private var backgroundView: some View {
    if #available(iOS 26.0, *) {
      RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous)
        .fill(.clear)
        .glassEffect()
    } else {
      RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous)
        .fill(.ultraThickMaterial)
        .overlay {
          RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous)
            .fill(layout.backgroundColor)
        }
        .shadow(
          color: layout.shadowColor,
          radius: 4,
          x: 0,
          y: 0
        )
    }
  }

  /// 응원가 정보
  private var cheerSongInfo: some View {
    HStack(spacing: 8) {
      coverImage
        .resizable()
        .scaledToFill()
        .frame(width: layout.imageSize, height: layout.imageSize)
        .clipShape(
          RoundedRectangle(cornerRadius: layout.imageCornerRadius)
        )

      VStack(alignment: .leading, spacing: .zero) {
        Text(playerName)
          .font(.SB9)
          .foregroundStyle(.grayBlack)
          .lineLimit(1)
        Text(title)
          .font(.R3)
          .foregroundStyle(.grayBlack)
          .lineLimit(1)
      }
    }
  }

  /// 버튼 모음
  private var controlContents: some View {
    HStack(spacing: layout.controlSpacing) {
      Button {
        onPlayPause()
      } label: {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
          .contentShape(.rect)
          .foregroundStyle(.black)
          .frame(width: layout.iconWidth)
      }
      .buttonStyle(.plain)

      Button {
        onNext()
      } label: {
        Image(systemName: "forward.fill")
          .contentShape(.rect)
          .foregroundStyle(.black)
          .frame(width: layout.iconWidth)
      }
      .buttonStyle(.plain)
    }
  }
}

/// iOS 버전별 대응을 하기 위한 구조체
private struct MiniPlayerLayout {
  let height: CGFloat
  let leadingSpacing: CGFloat
  let trailingSpacing: CGFloat
  let cornerRadius: CGFloat
  let backgroundColor: Color
  let shadowColor: Color
  let imageSize: CGFloat
  let imageCornerRadius: CGFloat
  let controlSpacing: CGFloat
  let iconWidth: CGFloat

    static var current: MiniPlayerLayout {
        .init(
            height: UIDevice.isIOS26OrLater ? 48 : 56,
            leadingSpacing: UIDevice.isIOS26OrLater ? 18 : 7,
            trailingSpacing: UIDevice.isIOS26OrLater ? 23 : 14,
            cornerRadius: UIDevice.isIOS26OrLater ? 0 : 16,
            backgroundColor: .grayWhite,
            shadowColor: UIDevice.isIOS26OrLater ? .clear : .gray200.opacity(0.3),
            imageSize: UIDevice.isIOS26OrLater ? 30 : 40,
            imageCornerRadius: UIDevice.isIOS26OrLater ? 5 : 10,
            controlSpacing: UIDevice.isIOS26OrLater ? 22 : 25,
            iconWidth: UIDevice.isIOS26OrLater ? 18 : 22
        )
    }
}
