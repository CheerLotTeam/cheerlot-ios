//
//  ModalRoute.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

enum PresentationStyle {
  case sheet
  case fullScreen
}

enum ModalRoute: Identifiable {
  // Sheet 스타일
  case cheerSongList(
    asset: TeamAssetVO,
    player: LineupPlayerVO,
    lineupPlayers: [LineupPlayerVO]
  )
  case lineupChange(
    lineupPlayer: LineupPlayerVO,
    onComplete: () -> Void
  )
  case teamChange(selectedTeamId: String)
  case inquiry
  case servicePage

  // FullScreen 스타일
  case lineupPlayback(startIndex: Int)
  case basePlayback(
    teamId: TeamID,
    song: CheerSongInfo,
    playerName: String
  )

  var id: String {
    switch self {
    case let .teamChange(selectedTeamId):
      return "teamChange_\(selectedTeamId)"
    default:
      return String(describing: self)
    }
  }

  var presentationStyle: PresentationStyle {
    switch self {
    case .cheerSongList, .lineupChange, .teamChange, .inquiry, .servicePage:
      return .sheet
    case .lineupPlayback, .basePlayback:
      return .fullScreen
    }
  }
}

extension AppCoordinator {
  @ViewBuilder
  func buildModalView(for route: ModalRoute) -> some View {
    let factory = ViewModelFactory.shared

    switch route {
    case let .cheerSongList(asset, player, lineupPlayers):
      CheerSongMenuSheetView(
        asset: asset,
        player: player,
        lineupPlayers: lineupPlayers,
      )
      .presentationDetents([.height(CGFloat((player.cheerSongs.count)) * 77 + 83)])
      .presentationDragIndicator(.visible)
    case let .lineupChange(lineupPlayer, onComplete):
      let viewModel = factory.createLineupChangeViewModel(lineupPlayer)

        NavigationStack {
            LineupChangeSheetView(
                viewModel: viewModel,
                onComplete: onComplete
            )
        }
      .presentationDetents([.large])
      .presentationDragIndicator(.hidden)
    case let .teamChange(selectedTeamId):
        let viewModel = factory.createTeamSelectViewModel(
            mode: .change,
            initialSelectedTeamId: selectedTeamId
          )
      NavigationStack {
        TeamSelectView(
          viewModel: viewModel,
          onClose: {
            self.dismissModal()
          },
          onCompleteForChange: {
            self.dismissModal()
          }
        )
      }
      .presentationDragIndicator(.visible)
    case let .inquiry:
      Color.clear
    case let .servicePage:
      Color.clear
    case let .lineupPlayback(startIndex):
      let viewModel = factory.createLineupPlaybackViewModel(startIndex: startIndex)

      NavigationStack {
        LineupPlaybackView(viewModel: viewModel)
      }
    case let .basePlayback(teamId, song, playerName):
      let viewModel = factory.createPlaybackViewModel(
        song: song,
        playerName: playerName
      )

      PlaybackView(
        asset: TeamAssetVO(teamId),
        viewModel: viewModel,
        onClose: {
          self.dismissModal()
        }
      )
    }
  }
}
