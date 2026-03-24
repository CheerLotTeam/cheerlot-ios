//
//  View+.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

extension View {
  /// 커스텀 폰트 스타일(`TypeStyle`)을 한 줄로 적용하는 확장 메서드
  func font(_ style: TypeStyle) -> some View {
    self
      .font(style.font)
      .kerning(style.letterSpacingPx)
      .lineSpacing(style.extraSpacing)
      .padding(.vertical, style.extraSpacing / 2)
  }

  /// 기본 커스텀 툴바 확장 메서드
  func customToolBar(
    leftItem: NavigationBarItem? = nil,
    centerItem: NavigationBarItem? = nil,
    rightItem: NavigationBarItem? = nil
  ) -> some View {
    self
      .navigationBarBackButtonHidden(true)
      .toolbar {
        if let leftItem {
          if #available(iOS 26.0, *) {
            if case .largeTitle = leftItem {
              ToolBarItemBuilder.buildItem(
                for: leftItem,
                placement: .topBarLeading
              )
              .sharedBackgroundVisibility(.hidden)
            } else {
              ToolBarItemBuilder.buildItem(
                for: leftItem,
                placement: .topBarLeading
              )
            }
          } else {
            ToolBarItemBuilder.buildItem(
              for: leftItem,
              placement: .topBarLeading
            )
          }
        }

        if let centerItem {
          ToolBarItemBuilder.buildItem(
            for: centerItem,
            placement: .principal
          )
        }

        if let rightItem {
          ToolBarItemBuilder.buildItem(
            for: rightItem,
            placement: .topBarTrailing
          )
        }
      }
  }

  /// leading에 LargeTitle과 trailing에 프로필 버튼을 가지는 toolbar 확장 메서드
  func toolBar_titleWithProfile(
    title: String,
    onProfileTap: @escaping () -> Void
  ) -> some View {
    customToolBar(
      leftItem: .largeTitle(title),
      rightItem: .profile(action: onProfileTap)
    )
  }

  /// leading에 cancel 버튼과 center에 경기 정보를 가지는 toolbar 확장 메서드
  func toolBar_gameInfo(
    date: String,
    teams: String,
    onClose: @escaping () -> Void
  ) -> some View {
    customToolBar(
      leftItem: .close(action: onClose),
      centerItem: .gameInfo(date: date, teams: teams)
    )
    .navigationBarTitleDisplayMode(.inline)
  }

  /// leading에 back 버튼과 center에 inlineTitle을 가지는 toolbar 확장 메서드
  func navigationBar_backWithTitle(
    title: String,
    onBack: @escaping () -> Void
  ) -> some View {
    customToolBar(
      leftItem: .back(action: onBack),
      centerItem: .inlineTitle(title)
    )
    .navigationBarTitleDisplayMode(.inline)
  }

  /// leading에 cancel 버튼과 center에 inlineTitle, trailing에 check 버튼을 가지는 toolbar 확장 메서드
  func toolBar_editMode(
    title: String,
    checkColor: Color = .gray800,
    onClose: @escaping () -> Void,
    onCheck: @escaping () -> Void
  ) -> some View {
    customToolBar(
      leftItem: .close(action: onClose),
      centerItem: .inlineTitle(title),
      rightItem: .check(action: onCheck, color: checkColor)
    )
    .navigationBarTitleDisplayMode(.inline)
  }

  /// lineupView의 리스트 cellAction(swipe, context menu)을 바로 사용할 수 있는 확장메서드
  func lineupCellActions(
    player: LineupPlayerVO,
    onChangePlayer: @escaping () -> Void,
    onSelectSong: @escaping (CheerSongVO) -> Void
  ) -> some View {
    self.modifier(
      LineupCellActionsModifier(
        player: player,
        onChangePlayer: onChangePlayer,
        onSelectSong: onSelectSong
      ))
  }

  /// 에러메시지 알럿을 띄우는 확장메서드
  func errorAlert(
    errorMessage: Binding<String?>
  ) -> some View {
    modifier(
      ErrorAlertModifier(
        errorMessage: errorMessage
      )
    )
  }

  /// 에러메시지와 재시도 알럿을 띄우는 확장메서드
  func errorWithRetryAlert(
    errorMessage: Binding<String?>,
    onRetry: @escaping () async -> Void
  ) -> some View {
    modifier(
      ErrorAlertWithRetryModifier(
        errorMessage: errorMessage,
        onRetry: onRetry)
    )
  }

  /// 커스텀 토스트 메시지 뷰를 띄울 수 있는 확장메서드
  func toastMessage(
    isPresented: Binding<Bool>,
    message: String,
    showCaution: Bool = true
  ) -> some View {
    modifier(
      CustomToastModifier(
        isPresented: isPresented,
        message: message,
        showCaution: showCaution
      )
    )
  }

  /// 조건에 따라 선택적으로 View Modifier를 적용하는 확장 메서드
  @ViewBuilder
  func ifApply<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  /// View의 background를 grayWhite로 적용하는 확장메서드
  func appBackground() -> some View {
    self.background(Color.grayWhite.ignoresSafeArea())
  }
}
