//
//  PlaybackSeekBar.swift
//  CheerLot
//
//  Created by 이승진 on 2/9/26.
//

import SwiftUI

/// 재생 화면에서 사용되는 SeekBar입니다.
struct PlaybackSeekBar: View {

  // MARK: - Properties
  /// 표시용 현재 재생 시간
  @Binding var value: Double

  /// 전체 재생 길이
  let maxValue: Double

  /// 드래그 시작/종료 상태 전달
  let onEditingChanged: (Bool) -> Void

  /// 드래그 종료 시 실제 seek 처리
  let onSeek: (Double) -> Void

  private let barHeight: CGFloat = 6
  private let thumbSize: CGFloat = 12

  /// 사용자가 SeekBar를 드래그 중인지 여부
  @State private var isDragging = false

  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width
      let progress =
        maxValue > 0
        ? min(max(value / maxValue, 0), 1)
        : 0
      let xPosition = width * progress

      ZStack(alignment: .leading) {
        // Background bar
        Capsule()
          .fill(.grayWhite.opacity(0.25))
          .frame(height: barHeight)

        // Progress bar
        Capsule()
          .fill(.grayWhite)
          .frame(width: xPosition, height: barHeight)
          .animation(isDragging ? nil : .linear(duration: 0.1), value: value)

        // Thumb
        Circle()
          .fill(.grayWhite)
          .frame(width: thumbSize, height: thumbSize)
          .offset(x: xPosition - thumbSize / 2)
          .animation(isDragging ? nil : .linear(duration: 0.1), value: value)
      }
      .frame(height: max(barHeight, thumbSize))
      .contentShape(Rectangle())
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { gesture in
            if !isDragging {
              isDragging = true
              onEditingChanged(true)
            }
            
            updateValue(
              locationX: gesture.location.x,
              width: width
            )
          }
          .onEnded { gesture in
            let newValue = updateValue(
              locationX: gesture.location.x,
              width: width
            )

            isDragging = false
            onSeek(newValue)
          }
      )
    }
    .frame(height: 24)
  }
}

extension PlaybackSeekBar {

  /// 드래그 위치를 기준으로 현재 재생 시간을 계산하는 함수
  @discardableResult
  private func updateValue(
    locationX: CGFloat,
    width: CGFloat
  ) -> Double {
    guard width > 0 else { return value }
    let percent = min(max(locationX / width, 0), 1)
    let newValue = percent * maxValue
    value = newValue
    return newValue
  }
}
