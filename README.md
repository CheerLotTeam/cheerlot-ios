# ⚾️ 쳐랏! iOS

![Swift](https://img.shields.io/badge/Swift-6-orange?style=flat-square&logo=swift)
![Platform](https://img.shields.io/badge/platform-iOS-blue?style=flat-square&logo=apple)
![watchOS](https://img.shields.io/badge/watchOS-supported-black?style=flat-square&logo=applewatch)
![WidgetKit](https://img.shields.io/badge/WidgetKit-enabled-5E5CE6?style=flat-square)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green?style=flat-square)
![Release](https://img.shields.io/github/v/release/CheerLotTeam/cheerlot-ios?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)

야구 팬이 선수별 응원가를 더 쉽고 빠르게 탐색하고 재생할 수 있도록 만든 SwiftUI 기반 iOS 프로젝트입니다.

<a href="https://apps.apple.com/app/%EC%B3%90%EB%9E%8F/id6748527115">
  <img src="https://github-production-user-asset-6210df.s3.amazonaws.com/75518683/268173445-322afec8-38fa-46ba-bbe0-3fffd0c93f5b.png" alt="appstore" height="80"/>
</a>

<br>

## About

**쳐랏**은 구단과 선수 중심으로 응원가를 찾고, 재생하고, 더 편하게 즐길 수 있도록 기획한 앱입니다.  
단순한 음원 재생을 넘어, 팀 테마 변경, 선수 검색, 위젯, Apple Watch 확장까지 고려하여 팬 경험을 더 직관적으로 제공하는 것을 목표로 합니다.

<br>

## Features

- 구단별 선수 목록 조회
- 선수별 응원가 탐색 및 재생
- 팀 선택에 따른 테마 변경
- 검색을 통한 선수 빠른 탐색
- Apple Watch 확장 타깃 지원
- 위젯 지원(예정)

<br>

## Tech Stack

### Frameworks
- SwiftUI
- WidgetKit

### Architecture
- MVVM

### Platforms
- iOS
- watchOS

### Tools
- Swift 6
- Fastlane

<br>

## Architecture

이 프로젝트는 **SwiftUI 기반의 MVVM 스타일 구조**를 중심으로 구성되어 있습니다.

- **View**
  - 화면을 선언적으로 구성하고 사용자 입력을 전달합니다.
- **ViewModel**
  - 화면 상태를 관리하고 View와 로직을 연결합니다.
- **Extensions**
  - iOS 앱뿐 아니라 **Widget**과 **Apple Watch 확장**까지 함께 고려해 구조를 확장하고 있습니다.

<br>

## Screenshots

| 홈 | 라인업 재생 | 선수 목록 | 재생 화면 | 검색 화면 |
|---|---|---|---|---|
| <img width="250" alt="홈" src="https://github.com/user-attachments/assets/15df9ba6-836e-4844-b23e-1db026803d91" /> | <img width="250" alt="라인업 재생" src="https://github.com/user-attachments/assets/aa508388-65b2-4f68-9a5c-093338cb8ddd" /> | <img width="250" alt="선수 목록" src="https://github.com/user-attachments/assets/2aaae84f-a012-4468-9605-1b11fcfdca98" /> | <img width="250" alt="재생 화면" src="https://github.com/user-attachments/assets/1ed9cbe9-9896-465e-a4f4-6e34819168f2" /> | <img width="250" alt="검색 화면" src="https://github.com/user-attachments/assets/404d2ec3-34f3-42da-8c18-bec8c89efffb" /> |

<br>
