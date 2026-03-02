//
//  PlayerResponseDTO.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

struct LineupDTO: Decodable {
    let teamCode: String
    let role: String
    let players: [StarterDTO]
}

struct StarterDTO: Decodable {
    let battingOrder: Int
    let playerCode: String
    let name: String
    let position: String
    let batThrow: String
    let backNumber: Int
    let cheerSongs: [CheerSongDTO]
}

struct AllPlayersDTO: Decodable {
    let teamCode: String
    let players: [PlayerDTO]
}

struct PlayerDTO: Decodable {
    let playerCode: String
    let name: String
    let teamCode: String
    let position: String
    let batThrow: String
    let backNumber: Int
    let battingOrder: Int?
    let cheerSongs: [CheerSongDTO]
}

struct CheerSongDTO: Decodable {
    let title: String
    let lyrics: String
    let audioUrl: String
}
