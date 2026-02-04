//
//  View+.swift
//  CheerLot
//
//  Created by 이현주 on 5/31/25.
//

import SwiftUI

extension View {
  //특정 corner radius 적용 함수
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCornerShape(radius: radius, corners: corners))
  }

  // 기본 style Text 커스텀 수정자 적용 함수
  func basicTextStyle(fontType: Font.Pretend, fontSize: CGFloat) -> some View {
    self.modifier(BasicTextStyle(fontType: fontType, fontSize: fontSize))
  }

  // pretend에 line height multiple와 letter spacing 수정자 적용 함수
  func lineHeightMultipleAdaptPretend(
    fontType: Font.Pretend, fontSize: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat = 0
  ) -> some View {
    self.modifier(
      LineHeightMultipleAdaptPretend(
        fontType: fontType, fontSize: fontSize, lineHeight: lineHeight, letterSpacing: letterSpacing
      ))
  }

  // freshman에 line height multiple와 letter spacing 수정자 적용 함수
  func lineHeightMultipleAdaptFreshman(
    fontSize: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat = 0
  ) -> some View {
    self.modifier(
      LineHeightMultipleAdaptFreshman(
        fontSize: fontSize, lineHeight: lineHeight, letterSpacing: letterSpacing))
  }

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
    func toolBar_matchInfo(
        date: String,
        teams: String,
        onClose: @escaping () -> Void
    ) -> some View {
        customToolBar(
            leftItem: .close(action: onClose),
            centerItem: .matchInfo(date: date, teams: teams)
        )
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
    }
    
    /// leading에 cancel 버튼과 center에 inlineTitle, trailing에 check 버튼을 가지는 toolbar 확장 메서드
    func toolBar_editMode(
        title: String,
        onClose: @escaping () -> Void,
        onCheck: @escaping () -> Void
    ) -> some View {
        customToolBar(
            leftItem: .close(action: onClose),
            centerItem: .inlineTitle(title),
            rightItem: .check(action: onCheck)
        )
    }
}
