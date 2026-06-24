# ⚾️ 쳐랏! iOS

![Swift](https://img.shields.io/badge/Swift-6-orange?style=flat-square&logo=swift)
![Platform](https://img.shields.io/badge/platform-iOS-blue?style=flat-square&logo=apple)
![watchOS](https://img.shields.io/badge/watchOS-supported-black?style=flat-square&logo=applewatch)
![WidgetKit](https://img.shields.io/badge/WidgetKit-enabled-5E5CE6?style=flat-square)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green?style=flat-square)
![Release](https://img.shields.io/github/v/release/CheerLotTeam/cheerlot-ios?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)

야구 팬이 선수별 응원가를 더 쉽고 빠르게 탐색하고 재생할 수 있도록 만든 SwiftUI 기반 iOS 앱입니다.

<a href="https://apps.apple.com/app/%EC%B3%90%EB%9E%8F/id6748527115">
  <img src="https://github-production-user-asset-6210df.s3.amazonaws.com/75518683/268173445-322afec8-38fa-46ba-bbe0-3fffd0c93f5b.png" alt="appstore" height="80"/>
</a>

<br>

## About

**쳐랏**은 야구 팬들이 구단과 선수 중심으로 응원가를 탐색하고 재생할 수 있도록 만든 앱입니다.  
선수별 응원가 재생, 팀 테마 변경, 선수 검색, 경기 정보 확인, WidgetKit 기반 위젯, Apple Watch 확장까지 고려하여 팬들이 더 빠르고 직관적으로 응원가를 즐길 수 있는 경험을 제공하는 것을 목표로 합니다.

<br>

## Features

- 구단별 선수 및 경기 정보 조회
- 팀 선수 응원가 검색 및 미니 플레이어를 통한 백그라운드 재생
- 라인업 기반 응원가 연속 재생
- 팀 선택 기반 앱 테마 적용
- WidgetKit 기반 홈/잠금 화면 위젯 지원
- Apple Watch를 통한 라인업 선수 응원가 가사 확인

<br>

## Tech Stack

### Frameworks
- SwiftUI
- WidgetKit
- SwiftData
- AVFoundation
- MediaPlayer
- WatchConnectivity

### Architecture
- MVVM + Clean Architecture
- Coordinator Pattern
- Repository
- UseCase

### Platforms
- iOS
- watchOS
- Widget Extension

### Tools
- Swift 6
- Xcode
- Fastlane

<br>

## Architecture

이 프로젝트는 **SwiftUI 기반 MVVM 구조**를 중심으로, 화면 상태 관리와 비즈니스 로직, 데이터 접근 책임을 분리하도록 구성되어 있습니다. Presentation, Domain, Data, Core 계층을 기준으로 기능을 나누고, ViewModel은 UseCase를 통해 도메인 로직을 실행하며 Repository는 데이터 소스 접근을 추상화합니다.

- **View**
  - SwiftUI 기반으로 화면을 선언적으로 구성합니다.
  - 사용자 입력을 ViewModel 또는 Coordinator로 전달합니다.

- **ViewModel**
  - 화면 상태와 사용자 액션을 관리합니다.
  - View에서 필요한 데이터를 가공하고 UseCase 호출 결과를 UI 상태로 변환합니다.

- **UseCase**
  - 앱의 주요 기능 단위 로직을 담당합니다.
  - ViewModel이 직접 Repository 구현체에 의존하지 않도록 중간 계층 역할을 합니다.

- **Repository**
  - 로컬 데이터와 원격 데이터 접근을 추상화합니다.
  - SwiftData, UserDefaults, 네트워크, WatchConnectivity 등 실제 데이터 소스와 도메인 계층 사이의 경계를 만듭니다.

- **Coordinator**
  - 화면 이동과 모달 표시 흐름을 관리합니다.
  - View 내부의 네비게이션 책임을 줄이고 화면 전환 로직을 분리합니다.

- ** DIContainer**
  - UseCase, Repository, ViewModel 생성 책임을 한곳에서 관리합니다.
  - iOS 앱, Widget, Apple Watch 확장 타깃에서 필요한 의존성을 각 실행 환경에 맞게 조립합니다.

- **Extensions**
  - iOS 앱뿐 아니라 WidgetKit과 Apple Watch 확장 타깃까지 고려하여 기능을 확장합니다.
  - 공통 도메인 흐름은 유지하되, 각 타깃에 필요한 저장소와 표현 계층을 분리합니다.

<br>

## Screenshots

| 홈 | 라인업 재생 | 선수 목록 | 재생 화면 | 검색 화면 |
|---|---|---|---|---|
| <img width="250" alt="홈" src="https://github.com/user-attachments/assets/15df9ba6-836e-4844-b23e-1db026803d91" /> | <img width="250" alt="라인업 재생" src="https://github.com/user-attachments/assets/aa508388-65b2-4f68-9a5c-093338cb8ddd" /> | <img width="250" alt="선수 목록" src="https://github.com/user-attachments/assets/2aaae84f-a012-4468-9605-1b11fcfdca98" /> | <img width="250" alt="재생 화면" src="https://github.com/user-attachments/assets/1ed9cbe9-9896-465e-a4f4-6e34819168f2" /> | <img width="250" alt="검색 화면" src="https://github.com/user-attachments/assets/404d2ec3-34f3-42da-8c18-bec8c89efffb" /> |
