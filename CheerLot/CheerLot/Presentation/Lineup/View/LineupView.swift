//
//  LineupView.swift
//  CheerLot
//
//  Created by 이현주 on 2/5/26.
//

import SwiftUI

struct LineupView: View {
  @State private var viewModel: LineupViewModel

  @Environment(AppCoordinator.self) private var coordinator

  init(viewModel: LineupViewModel) {
    _viewModel = State(initialValue: viewModel)
  }

  // MARK: - Layout Constants
  private let teamNameHeight: CGFloat = 44.5
  private let gameInfoHeight: CGFloat = 26.5
  private let cardTopPadding: CGFloat = 20
  private let cardBottomPadding: CGFloat = 10
  private let cardSpacing: CGFloat = 8
  private let separatorHeight: CGFloat = 1
  private let safeAreaVerticalPadding: CGFloat = 10
  private let safeAreaHorizontalPadding: CGFloat = 20

  var body: some View {
    GeometryReader { geo in
      let cardHeight = max(0, geo.size.height - safeAreaVerticalPadding * 2)
      let cardWidth = max(0, geo.size.width - safeAreaHorizontalPadding * 2)

      ZStack {
        if let asset = viewModel.asset {
          ScrollView {
            lineupCard(asset: asset, cardHeight: cardHeight, cardWidth: cardWidth)
          }
          .frame(width: geo.size.width)
          .scrollIndicators(.hidden)
          .refreshable {
            await viewModel.refresh()
          }
        } else {
          Color.clear
        }

        if viewModel.isLoading {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        }
      }
      .toolBar_titleWithProfile(title: "선발 라인업") {
        coordinator.push(.settings)
      }
    }
    .task {
      await viewModel.onAppear()
    }
    .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
      Button("다시 시도") {
        viewModel.errorMessage = nil
        Task {
          await viewModel.onAppear()
        }
      }
      Button("취소", role: .cancel) {
        viewModel.errorMessage = nil
      }
    } message: {
      if let error = viewModel.errorMessage {
        Text(error)
      }
    }
  }

  // MARK: - Height 계산
  private func listHeight(cardHeight: CGFloat) -> CGFloat {
    max(
      0,
      cardHeight - teamNameHeight - gameInfoHeight - cardTopPadding - cardBottomPadding
        - cardSpacing * 2)
  }

  private func cellHeight(cardHeight: CGFloat) -> CGFloat {
    let totalSeparatorHeight = separatorHeight * 8
    let availableHeight = listHeight(cardHeight: cardHeight) - totalSeparatorHeight
    return max(0, availableHeight / 9)
  }

  private func noGameMessage(for status: GameStatus) -> String {
    switch status {
    case .offDay: return "오늘은 경기가 없는 날이에요"
    case .seasonEnded: return "다음 시즌 준비중이에요"
    case .playingToday: return ""
    }
  }
}

extension LineupView {
  private func lineupCard(asset: LineupAssetVO, cardHeight: CGFloat, cardWidth: CGFloat)
    -> some View
  {
    ZStack {
      asset.primaryColor

      asset.cardBackgroundGradient
        .opacity(0.2)

      Image(.teamCardBG)
        .resizable()
        .scaledToFill()
        .opacity(0.75)
        .blendMode(.softLight)

      cardContents(asset: asset, cardHeight: cardHeight, cardWidth: cardWidth)
    }
    .frame(width: cardWidth, height: cardHeight)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .strokeBorder(asset.cardStrokeColor, lineWidth: 2)
    )
  }

  private func cardContents(asset: LineupAssetVO, cardHeight: CGFloat, cardWidth: CGFloat) -> some View
  {
    ZStack {
      VStack(spacing: cardSpacing) {

        if let gameInfo = viewModel.gameInfo {
          teamName(asset: asset, gameInfo: gameInfo)
          gameInfoView(asset: asset, gameInfo: gameInfo)
        }

        if viewModel.shouldShowLineup {
          lineupList(asset: asset, cardHeight: cardHeight, cardWidth: cardWidth)
        }
      }
      .padding(.top, cardTopPadding)
      .padding(.bottom, cardBottomPadding)
      .frame(maxHeight: .infinity, alignment: .top)  // header 상단 고정

      if !viewModel.shouldShowLineup {
        hasNoGameView(asset: asset, status: viewModel.gameStatus)
      }
    }
  }

  private func teamName(asset: LineupAssetVO, gameInfo: LineupGameInfoVO) -> some View {
    Text(gameInfo.teamEnglishName)
      .font(.T1)
      .foregroundStyle(.grayWhite)
      .shadow(
        color: asset.cardTextShadowColor,
        radius: 8,
        x: 0,
        y: 1
      )
  }

  private func gameInfoView(asset: LineupAssetVO, gameInfo: LineupGameInfoVO) -> some View {
    HStack(spacing: 8) {
      Text(gameInfo.gameInfoText)
        .font(.M5_gameState)

      if let starterPitcher = gameInfo.starterPitcher {
        HStack(spacing: 2) {
          Image(.pitcher)
            .resizable()
            .frame(width: 12, height: 12)
            .scaledToFit()

          Text(starterPitcher)
            .font(.B4)
        }
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 6)
    .background(Capsule().fill(asset.gameInfoBgColor))
    .foregroundColor(.grayWhite)
  }

  private func lineupList(asset: LineupAssetVO, cardHeight: CGFloat, cardWidth: CGFloat)
    -> some View
  {
    List {
      ForEach(Array(viewModel.lineupPlayers.enumerated()), id: \.element.id) { index, player in
        VStack(spacing: 0) {
          LineupMemberCell(
            player: player,
            asset: asset
          )
          .frame(height: cellHeight(cardHeight: cardHeight))
          .padding(.horizontal, 5.5)
          .onTapGesture {
            if player.cheerSongs.count >= 2 {
              coordinator.presentModal(
                .cheerSongList(
                  asset: asset.base,
                  player: player,
                  lineupPlayers: viewModel.lineupPlayers
                )
              )
            } else if let firstSong = player.cheerSongs.first {
              goToLineupPlayback()
            }
          }

          if index < viewModel.lineupPlayers.count - 1 {
            DashedLine()
              .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
              .foregroundColor(asset.listLineColor)
              .frame(height: separatorHeight)
          }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .lineupCellActions(
          player: player,
          onChangePlayer: {
            coordinator.presentModal(
              .lineupChange(
                lineupPlayer: player,
                onComplete: {
                  Task {
                    await viewModel.refresh()
                  }
                }))
          },
          onSelectSong: { cheerSong in
            goToLineupPlayback()
          }
        )
      }
    }
    .frame(width: cardWidth, height: listHeight(cardHeight: cardHeight))
    .listStyle(.plain)
    .scrollDisabled(true)
    .scrollContentBackground(.hidden)
    .clipShape(Rectangle())
    .contentShape(Rectangle())
  }

  private func hasNoGameView(asset: LineupAssetVO, status: GameStatus) -> some View {
    VStack(spacing: 24) {
      Spacer()

      Text(noGameMessage(for: status))
        .font(.M3)
        .foregroundStyle(asset.positionTextColor)

      Button {
        viewModel.toggleShowRecentLineup()
      } label: {
        Text("최근 경기 라인업 보기")
          .font(.SB8)
          .foregroundStyle(.grayWhite)
          .padding(.vertical, 6)
          .padding(.horizontal, 10)
          .background(
            ZStack {
              asset.primaryColor
              asset.lastestGameButtonGradient.opacity(0.2)
              asset.positionTextColor.opacity(0.2)
            }
          )
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .strokeBorder(asset.lastestGameButtonStrokeColor, lineWidth: 1.5)
          )
      }
      Spacer()
    }
  }

  private func goToLineupPlayback() {
    // TODO: - LineupPlayback으로 넘기기
  }
}
