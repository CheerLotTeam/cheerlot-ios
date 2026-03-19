//
//  ServerErrorResponseDTO.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

struct ServerErrorResponseDTO: Decodable {
  let message: String
  let errorCode: String
}
