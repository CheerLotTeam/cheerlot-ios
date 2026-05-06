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
  private let separatorHeight: CGFloat = 1
  private let safeAreaVerticalPadding: CGFloat = 10
  private let safeAreaHorizontalPadding: CGFloat = 20

  private func isCompact(cardHeight: CGFloat) -> Bool {
    cardHeight < 550
  }

  private func cardTopPadding(cardHeight: CGFloat) -> CGFloat {
    isCompact(cardHeight: cardHeight) ? 12 : 20
  }

  private func cardBottomPadding(cardHeight: CGFloat) -> CGFloat {
    isCompact(cardHeight: cardHeight) ? 6 : 10
  }

  private func cardSpacing(cardHeight: CGFloat) -> CGFloat {
    isCompact(cardHeight: cardHeight) ? 2 : 4
  }

  var body: some View {
    GeometryReader { geo in
      let cardHeight = max(0, geo.size.height - safeAreaVerticalPadding * 2)
      let cardWidth = max(0, geo.size.width - safeAreaHorizontalPadding * 2)

      ZStack {
        if let asset = viewModel.asset {
          ScrollView {
            lineupCard(asset: asset, cardHeight: cardHeight, cardWidth: cardWidth)
              .padding(.top, UIDevice.isIOS26OrLater ? 3 : 10)
          }
          .frame(width: geo.size.width)
          .scrollIndicators(.hidden)
          .refreshable {
            await viewModel.loadData()
          }
        } else {
          Color.clear
        }

        if viewModel.isLoading {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .appBackground()
        }
      }
      .toolBar_titleWithProfile(title: "선발 라인업") {
        coordinator.push(.settings)
      }
    }
    .appBackground()
    .task {
      await viewModel.onAppear()
    }
    .errorWithRetryAlert(errorMessage: $viewModel.errorMessage) {
      await viewModel.onAppear()
    }
    .toastMessage(
      isPresented: $viewModel.showToast,
      message: viewModel.toastMessage
    )
  }

  // MARK: - Height 계산
  private func listHeight(cardHeight: CGFloat) -> CGFloat {
    max(
      0,
      cardHeight - teamNameHeight - gameInfoHeight - cardTopPadding(cardHeight: cardHeight)
        - cardBottomPadding(cardHeight: cardHeight) - cardSpacing(cardHeight: cardHeight) * 3
    )
  }

  private func cellHeight(cardHeight: CGFloat) -> CGFloat {
    let totalSeparatorHeight = separatorHeight * 9
    let availableHeight = listHeight(cardHeight: cardHeight) - totalSeparatorHeight
    return max(0, availableHeight / 9)
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

  private func cardContents(asset: LineupAssetVO, cardHeight: CGFloat, cardWidth: CGFloat)
    -> some View
  {
    ZStack {
      VStack(spacing: cardSpacing(cardHeight: cardHeight)) {

        if let gameInfo = viewModel.gameInfo {
          teamName(asset: asset, gameInfo: gameInfo, cardHeight: cardHeight)
            .padding(.bottom, cardSpacing(cardHeight: cardHeight))
          gameInfoView(asset: asset, gameInfo: gameInfo)
        }

        if viewModel.shouldShowLineup {
          lineupList(asset: asset, cardHeight: cardHeight, cardWidth: cardWidth)
        }
      }
      .padding(.top, cardTopPadding(cardHeight: cardHeight))
      .padding(.bottom, cardBottomPadding(cardHeight: cardHeight))
      .frame(width: cardWidth, height: cardHeight, alignment: .top)

      if !viewModel.shouldShowLineup {
        hasNoGameView(asset: asset)
      }
    }
  }

  private func teamName(
    asset: LineupAssetVO,
    gameInfo: LineupGameInfoVO,
    cardHeight: CGFloat
  ) -> some View {
    Text(gameInfo.teamEnglishName)
      .font(.T1)
      .foregroundStyle(.grayWhite)
      .lineLimit(1)
      .minimumScaleFactor(0.9)
      .frame(height: teamNameHeight, alignment: .center)
      .shadow(
        color: asset.cardTextShadowColor,
        radius: 8,
        x: 0,
        y: 1
      )
  }

  private func gameInfoView(asset: LineupAssetVO, gameInfo: LineupGameInfoVO) -> some View {
    HStack(spacing: 8) {
      Text(viewModel.displayGameInfoText)
        .font(.M5_gameState)

      if viewModel.shouldShowLineup || viewModel.gameStatus == .lineupPending,
        let starterPitcher = viewModel.displayStarterPitcherName
      {
        HStack(spacing: 2) {
          Image(.pitcher)
            .resizable()
            .scaledToFit()
            .frame(width: 12)

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

  private func lineupList(
    asset: LineupAssetVO,
    cardHeight: CGFloat,
    cardWidth: CGFloat
  )
    -> some View
  {
    List {
      ForEach(Array(viewModel.lineupPlayers.enumerated()), id: \.element.id) { index, player in
        VStack(spacing: 0) {
          LineupMemberCell(
            player: player,
            asset: asset,
            isCompact: isCompact(cardHeight: cardHeight)
          )
          .frame(height: cellHeight(cardHeight: cardHeight))
          .padding(.horizontal, 5.5)
          .contentShape(Rectangle())
          .onTapGesture {
            let action = viewModel.handlePlayerTap(player: player)
            switch action {
            case .showSongList(let player):
              coordinator.presentModal(
                .cheerSongList(
                  asset: asset.base,
                  player: player,
                  lineupPlayers: viewModel.lineupPlayers
                )
              )
            case .goToPlayback(let startIndex):
              coordinator.presentModal(.lineupPlayback(startIndex: startIndex))
            case .none:
              break
            }
          }

          if index < viewModel.lineupPlayers.count - 1 {
            DashedLine()
              .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
              .foregroundColor(asset.listLineColor)
              .frame(height: separatorHeight)
          } else {
            Color.clear
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
                    await viewModel.loadData()
                  }
                }
              )
            )
          },
          onSelectSong: { cheerSong in
            let action = viewModel.handleSongSelect(song: cheerSong)
            switch action {
            case .goToPlayback(let startIndex):
              coordinator.presentModal(.lineupPlayback(startIndex: startIndex))
            default:
              break
            }
          }
        )
      }
    }
    .frame(width: cardWidth, height: listHeight(cardHeight: cardHeight))
    .listStyle(.plain)
    .scrollDisabled(true)
    .scrollContentBackground(.hidden)
    .contentMargins(.vertical, 0, for: .scrollContent)
    .environment(\.defaultMinListRowHeight, 0)
    .clipShape(Rectangle())
  }

  private func hasNoGameView(asset: LineupAssetVO) -> some View {
    VStack(spacing: 24) {
      Spacer()

      Text(viewModel.noGameMessage)
        .font(.M3)
        .foregroundStyle(asset.positionTextColor)

      Button {
        viewModel.toggleShowLineup()
      } label: {
        Text(viewModel.toggleShowLineupMessage)
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
}
