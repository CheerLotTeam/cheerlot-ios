//
//  HomeTeamAssetVO.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 4/3/26.
//

import SwiftUI

struct HomeTeamAssetVO {
  let base: WidgetTeamAssetVO

  init(base: WidgetTeamAssetVO) {
    self.base = base
  }

  var shortName: String { base.shortName }
  var primaryColor: Color { base.primaryColor }
  var secondaryColor: Color { base.secondaryColor }
  var primaryPalette: Color.TeamPrimaryPalette { base.primaryPalette }
  var secondaryPalette: Color.TeamSecondaryPalette { base.secondaryPalette }
  var coverImage: Image { base.coverImage }
  var noCoverImage: Image { base.noCoverImage }

  var widgetBackgroundGradient: LinearGradient {
    LinearGradient(
      colors: [
        base.primaryPalette.color600,
        base.primaryPalette.color200,
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }
}
