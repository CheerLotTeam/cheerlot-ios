//
//  LineupPlaybackView.swift
//  CheerLot
//
//  Created by 이현주 on 3/9/26.
//

import SwiftUI

struct LineupPlaybackView: View {
  // MARK: - Environment

  @Environment(\.scenePhase) private var scenePhase
  @Environment(AppCoordinator.self) private var coordinator

  // MARK: - State

  @State private var viewModel: LineupPlaybackViewModel
  @State private var scrollPosition: Int?  // itemsArray 전체 기준 현재 중앙 아이템의 인덱스
  @State private var itemsArray: [[CarouselItemVO]] = []  // 무한 스크롤을 위해  carouselItems를 3벌 복제
  @State private var isRebalancing: Bool = false  // 재배치 애니메이션 중 onChange 방지 플래그
  @State private var lastRealIndex: Int?  // 실제 인덱스 변경 여부 확인을 위한 이전 인덱스

  // MARK: - Layout Constants

  private let animationDuration: TimeInterval = 0.3

  private var pageWidth: CGFloat {
    UIScreen.width - 56
  }

  private var pageHeight: CGFloat {
    pageWidth * 1.596
  }

  // MARK: - Computed

  // itemsArray를 평탄화한 전체 아이템
  private var itemsTemp: [CarouselItemVO] {
    itemsArray.flatMap { $0 }
  }

  // 현재 실제 players 인덱스 (페이지 인디케이터용)
  private var currentRealIndex: Int {
    guard let scrollPosition else { return 0 }
    guard !viewModel.carouselItems.isEmpty else { return 0 }
    return scrollPosition % viewModel.carouselItems.count
  }

  // MARK: - Init

  init(viewModel: LineupPlaybackViewModel) {
    _viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    ZStack {
      if let asset = viewModel.asset {
        asset.playbackBackgroundGradient
          .ignoresSafeArea()
      }

      if viewModel.lineupPlayers.isEmpty {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .appBackground()
      } else if let asset = viewModel.asset {
        VStack(spacing: 23) {
          cardCarouselView(asset: asset)
            .frame(height: pageHeight)

          pageIndicator(asset: asset)
        }
      }
    }
    .appBackground()
    .toolBar_gameInfo(
      date: viewModel.gameDate, teams: viewModel.teamsText,
      onClose: {
        viewModel.stopPlayback()
        coordinator.dismissModal()
      }
    )
    .task {
      await viewModel.onAppear()
      let items = viewModel.carouselItems
      guard !items.isEmpty else { return }
      itemsArray = [items, items, items]
      scrollPosition = items.count + viewModel.startIndex
      lastRealIndex = viewModel.startIndex
    }
    .onDisappear {
      viewModel.stopPlayback()
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase != .active {
        viewModel.pausePlayback()
      }
    }
    .onChange(of: viewModel.currentPlaybackIndex) { _, newValue in
      let items = viewModel.carouselItems
      guard !items.isEmpty else { return }
      guard let currentPosition = scrollPosition else { return }

      guard viewModel.isSyncingFromPlayback else { return }
      withAnimation(.easeInOut(duration: animationDuration)) {
        scrollPosition = currentPosition + 1
      }
      lastRealIndex = newValue
    }
  }
}

extension LineupPlaybackView {
  private func cardCarouselView(asset: LineupPlaybackAssetVO) -> some View {
    let widthDifference = UIScreen.width - pageWidth
    let itemCount = viewModel.carouselItems.count

    return ScrollView(.horizontal) {
      LazyHStack(spacing: 0) {
        ForEach(0..<itemsTemp.count, id: \.self) { index in
          let item = itemsTemp[index]

          cardView(
            asset: asset,
            item: item,
            itemIndex: index % max(itemCount, 1),
            pageHeight: pageHeight
          )
          .id(index)
          .frame(width: pageWidth)
          .scrollTransition(.interactive, axis: .horizontal) { content, phase in
            content
              .scaleEffect(phase.isIdentity ? 1.0 : 0.91)
              .opacity(phase.isIdentity ? 1.0 : 0.2)
          }
        }
      }
      .scrollTargetLayout()
    }
    .contentMargins(widthDifference / 2, for: .scrollContent)
    .scrollTargetBehavior(.viewAligned)
    .scrollPosition(id: $scrollPosition, anchor: .center)
    .scrollIndicators(.hidden)
    .onChange(of: scrollPosition) {
      guard let scrollPosition, !isRebalancing else { return }
      guard itemCount > 0 else { return }

      // 앞쪽 1/3 영역 진입 시 재배치
      if scrollPosition < itemCount {
        isRebalancing = true
        let items = viewModel.carouselItems
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
          itemsArray.removeLast()
          itemsArray.insert(items, at: 0)
          self.scrollPosition = scrollPosition + itemCount
          self.isRebalancing = false
        }
        return
      }

      // 뒤쪽 1/3 영역 진입 시 재배치
      if scrollPosition >= itemCount * 2 {
        isRebalancing = true
        let items = viewModel.carouselItems
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
          itemsArray.removeFirst()
          itemsArray.append(items)
          self.scrollPosition = scrollPosition - itemCount
          self.isRebalancing = false
        }
        return
      }

      let realIndex = scrollPosition % itemCount
      guard lastRealIndex != realIndex else { return }

      lastRealIndex = realIndex
      viewModel.didScrollToCard(at: realIndex)
    }
  }

  @ViewBuilder
  private func cardView(
    asset: LineupPlaybackAssetVO,
    item: CarouselItemVO,
    itemIndex: Int,
    pageHeight: CGFloat
  ) -> some View {
    LineupPlayCard(
      asset: asset,
      battingOrder: item.player.battingOrder ?? 0,
      name: item.player.name,
      title: item.cheerSong.title,
      lyrics: item.cheerSong.lyrics,
      isPlaying: viewModel.isPlaying && currentRealIndex == itemIndex,
      onTapPlayPause: {
        viewModel.togglePlayback()
      }
    )
    .frame(height: pageHeight)
  }

  private func pageIndicator(asset: LineupPlaybackAssetVO) -> some View {
    HStack(spacing: 8) {
      ForEach(0..<viewModel.carouselItems.count, id: \.self) { index in
        Capsule()
          .fill(
            index == currentRealIndex
              ? asset.selectedPageIndicatorColor : asset.unselectedPageIndicatorColor
          )
          .frame(
            width: index == currentRealIndex ? 10 : 8, height: index == currentRealIndex ? 10 : 8
          )
          .animation(.spring(duration: 0.3), value: currentRealIndex)
      }
    }
    .padding(.all, 1)
  }
}
