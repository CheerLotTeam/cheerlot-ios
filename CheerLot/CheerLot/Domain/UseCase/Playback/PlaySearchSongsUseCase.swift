//
//  PlaySearchSongsUseCase.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

protocol PlaySearchSongsUseCase {
  func play(
    selectedResult: SearchResultVO,
    allResults: [SearchResultVO],
    coverImageName: String?,
    isGameDay: Bool
  )
}
