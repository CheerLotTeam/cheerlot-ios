//
//  PlaybackView.swift
//  CheerLot
//
//  Created by 이승진 on 2/8/26.
//

import SwiftUI

/// 전체 전수 명단에서 응원가를 재생하면 보여지는 뷰입니다.
struct PlaybackView: View {

  // MARK: - Properties
  let asset: TeamAssetVO

  // TODO: - 지울 예정 (UI 목적)
  @State private var isPlaying: Bool = false
  @State private var currentTime: Double = 30
  private let duration: Double = 90

  // MARK: - Body
  var body: some View {
    VStack(spacing: 40) {
      header
      content
      footer
    }
    .background(asset.primaryColor)
    .ignoresSafeArea()
  }
}

extension PlaybackView {
  /// 선수 이름 + 응원가 종류
  private var header: some View {
    VStack(spacing: .zero) {
      Text("김지찬")
        .font(.B3)
        .foregroundStyle(.grayWhite)

      Text("기본 응원가")
        .font(.SB8)
        .foregroundStyle(.gray200)
    }
    .padding(.top, 90)
  }

  /// 가사뷰
  private var content: some View {
    ScrollView(showsIndicators: true) {
      LazyVStack(alignment: .leading) {
        Text("하이하이하이하이\n하이하이\n하이")
      }
      .multilineTextAlignment(.leading)
      .font(.B1_1)
      .foregroundStyle(.grayWhite)
    }
    .padding(.horizontal, 24)
  }

  /// 재생바 + 컨트롤뷰
  private var footer: some View {
    VStack(spacing: 20) {
      progressView
      controlView
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 36)
  }

  /// 재생바
  private var progressView: some View {
    VStack(spacing: 8) {
      PlaybackSeekBar(
        value: $currentTime,
        maxValue: duration,
        onSeek: { _ in }
      )

      HStack {
        Text("00:00")
        Spacer()
        Text("01:30")
      }
      .font(.M5)
      .foregroundStyle(.gray300)
      .padding(.bottom, 4)
    }
  }

  /// 컨트롤
  private var controlView: some View {
    HStack(spacing: 44) {
      playbackButton("backward.fill")
      playbackButton(
        isPlaying ? "pause.fill" : "play.fill",
        center: true
      ) {
        isPlaying.toggle()
      }
      playbackButton("forward.fill")
    }
  }

  /// 같은 버튼 스타일을 씌우기 위한 함수
  private func playbackButton(
    _ systemName: String,
    center: Bool = false,
    action: @escaping () -> Void = {}
  ) -> some View {
    Button {
      action()
    } label: {
      Image(systemName: systemName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(
          width: center ? 28 : 36,
          height: center ? 38 : 29
        )
        .foregroundStyle(.grayWhite)
    }
    .buttonStyle(PlaybackButtonStyle(size: 56))
  }
}

#Preview {
    PlaybackView(asset: TeamAssetVO(TeamDataSource.toEntity(.samsung).id))
}
