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
  let asset: PlaybackAssetVO
  let onClose: () -> Void

  @State private var viewModel: PlaybackViewModel
  @State private var dragOffsetY: CGFloat = 0
  @State private var isScrolledToBottom: Bool = false

  init(
    asset: PlaybackAssetVO,
    viewModel: PlaybackViewModel,
    onClose: @escaping () -> Void
  ) {
    self.asset = asset
    self.onClose = onClose
    _viewModel = State(initialValue: viewModel)
  }

  // MARK: - Body
  var body: some View {
    ZStack {
      asset.primaryColor
        .ignoresSafeArea()

      MetalBackgroundView()
        .ignoresSafeArea()
        .allowsHitTesting(false)

      Color.grayBlack.opacity(0.1)
        .ignoresSafeArea()
        .allowsHitTesting(false)

      VStack(spacing: 14) {
        topBar
        mainView
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .padding(.top, 40)
    }
    .ignoresSafeArea()
    .offset(y: dragOffsetY)
    .animation(.spring(duration: 0.25), value: dragOffsetY)
    .onAppear { viewModel.onAppear() }
    .onDisappear { viewModel.onDisappear() }
  }
}

extension PlaybackView {
  private var topBar: some View {
    ZStack {
      Color.clear

      Capsule()
        .fill(.grayWhite.opacity(0.5))
        .frame(width: 60, height: 5)
    }
    .padding(.bottom, -20)
    .frame(maxWidth: .infinity)
    .frame(height: 44)
    .contentShape(Rectangle())
    .onTapGesture { handleClose() }
    .gesture(
      DragGesture()
        .onChanged { value in
          guard value.translation.height > 0 else { return }
          dragOffsetY = value.translation.height
        }
        .onEnded { value in
          let shouldClose = value.translation.height > 40

          if shouldClose {
            handleClose()
          } else {
            dragOffsetY = 0
          }
        }
    )
  }

  private var mainView: some View {
    VStack(spacing: 40) {
      header
      content
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      footer
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }

  /// 선수 이름 + 응원가 종류
  private var header: some View {
    VStack(spacing: .zero) {
      Text(viewModel.playerName)
        .font(.B3)
        .foregroundStyle(.grayWhite)

      Text(viewModel.title)
        .font(.SB8)
        .foregroundStyle(.gray200)
    }
  }

  /// 가사뷰
  private var content: some View {
    ViewThatFits(in: .vertical) {
      lyricsText

      ScrollView(.vertical, showsIndicators: false) {
        lyricsText
      }
      .onScrollGeometryChange(for: Bool.self) { geo in
        geo.contentOffset.y >= geo.contentSize.height - geo.containerSize.height - 1
      } action: { _, isBottom in
        isScrolledToBottom = isBottom
      }
      .mask(
        Group {
          if isScrolledToBottom {
            Color.black
          } else {
            asset.lyricsScrollMaskGradient
          }
        }
      )
    }
    .padding(.horizontal, 24)
  }

  private var lyricsText: some View {
    Text(viewModel.lyrics.replacingOccurrences(of: "\\n", with: "\n"))
      .multilineTextAlignment(.leading)
      .font(.B1_1)
      .foregroundStyle(.grayWhite)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  /// 재생바 + 컨트롤뷰
  private var footer: some View {
    VStack(spacing: 20) {
      progressView
      controlView
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
  }

  /// 재생바
  private var progressView: some View {
    VStack(spacing: 4) {
      PlaybackSeekBar(
        value: $viewModel.progress,
        maxValue: viewModel.seekBarMaxValue,
        onEditingChanged: { viewModel.isSeeking = $0 },
        onSeek: { viewModel.seek(to: $0) }
      )

      HStack {
        Text(viewModel.progress.asTimeString)
          .font(.M5)
          .foregroundStyle(.grayWhite)

        Spacer()
        Text(viewModel.duration.asTimeString)
          .font(.M5)
          .foregroundStyle(.grayWhite).opacity(0.5)

      }
    }
  }

  /// 컨트롤
  private var controlView: some View {
    HStack(spacing: 44) {
      playbackButton("backward.fill") {
        viewModel.playPrevious()
      }
      .disabled(!viewModel.canSkipManually)
      .opacity(viewModel.canSkipManually ? 1 : 0.3)
      playbackButton(
        viewModel.isPlaying ? "pause.fill" : "play.fill",
        center: true
      ) {
        viewModel.togglePlayback()
      }
      playbackButton("forward.fill") {
        viewModel.playNext()
      }
      .disabled(!viewModel.canSkipManually)
      .opacity(viewModel.canSkipManually ? 1 : 0.3)
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
        .font(.system(size: center ? 32 : 24, weight: .regular))
        .foregroundStyle(.grayWhite)
    }
    .buttonStyle(PlaybackButtonStyle(size: 56))
  }
  
  private func handleClose() {
    viewModel.closePlayback()
    onClose()
  }
}
