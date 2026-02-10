//
//  CheerSongInfo.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

struct CheerSongInfo: Identifiable, Hashable, Equatable {
    let id: Int
    let playerId: PlayerID
    let title: String
    let lyrics: String
    let audioURL: String
    
    init(id: Int, playerId: PlayerID, title: String, lyrics: String, audioURL: String) {
        self.id = id
        self.playerId = playerId
        self.title = title
        self.lyrics = lyrics
        self.audioURL = audioURL
    }
}
