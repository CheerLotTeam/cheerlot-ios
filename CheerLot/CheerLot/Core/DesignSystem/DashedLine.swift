//
//  DashedLine.swift
//  CheerLot
//
//  Created by 이현주 on 2/19/26.
//

import SwiftUI

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

// MARK: - 점선
//DashedLine()
//    .stroke(...
//    .foregroundColor(...
