//
//  TightLineHeightText.swift
//  CheerLot
//
//  Created by 이현주 on 3/23/26.
//

import SwiftUI

struct TightLineHeightText: UIViewRepresentable {
    let text: String
    let style: TypeStyle
    var color: UIColor

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        applyStyle(to: label)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        applyStyle(to: uiView)
    }

    private func applyStyle(to label: UILabel) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.size * style.lineHeight
        paragraphStyle.maximumLineHeight = style.size * style.lineHeight
        paragraphStyle.alignment = .center
        let baselineOffset = (style.size * style.lineHeight - style.uiFont.lineHeight) / 2

        label.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: style.uiFont,
                .kern: style.letterSpacingPx,
                .foregroundColor: color,
                .baselineOffset: baselineOffset
            ]
        )
    }
}
