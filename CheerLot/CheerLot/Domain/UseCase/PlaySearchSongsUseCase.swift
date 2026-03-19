//
//  PlaySearchSongsUseCase.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

protocol PlaySearchSongsUseCase {
  func play(result: SearchResultVO, coverImageName: String?)
}
