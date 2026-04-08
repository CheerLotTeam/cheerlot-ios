//
//  Color+.swift
//  CheerLot
//
//  Created by 이승진 on 4/1/26.
//

import SwiftUI

extension Color {
  struct TeamColorSet {
    let primary: Color
    let secondary: Color
  }

  struct TeamPrimaryPalette {
    let color100: Color
    let color200: Color
    let color300: Color
    let color500: Color
    let color600: Color
  }

  struct TeamSecondaryPalette {
    let color100: Color
    let color200: Color
    let color300: Color
    let color500: Color
    let color600: Color
  }
    
  static let appPrimary = Color.sky600
  static let appSecondary = Color.seam400

  static let hanwhaPrimary = Color.hhOrange400
  static let hanwhaSecondary = Color.hhOrange400

  static let lgPrimary = Color.lgRed400
  static let lgSecondary = Color.lgRed400

  static let lottePrimary = Color.ltNavy400
  static let lotteSecondary = Color.ltRed400

  static let samsungPrimary = Color.ssBlue400
  static let samsungSecondary = Color.ssBlue400

  static let ncPrimary = Color.ncDeepblue400
  static let ncSecondary = Color.ncGold400

  static let ktPrimary = Color.ktJetblack400
  static let ktSecondary = Color.ktRed400

  static let ssgPrimary = Color.ssgDeepred400
  static let ssgSecondary = Color.ssgDeepred400

  static let doosanPrimary = Color.dsMidnight400
  static let doosanSecondary = Color.dsRed400

  static let kiwoomPrimary = Color.kwBurgundy400
  static let kiwoomSecondary = Color.kwBurgundy400

  static let kiaPrimary = Color.kiaScarlet400
  static let kiaSecondary = Color.kiaScarlet400

  static func teamPrimaryPalette(for assetPrefix: String) -> TeamPrimaryPalette {
    switch assetPrefix {
    case "hh":
      return TeamPrimaryPalette(
        color100: .hhOrange100, color200: .hhOrange200, color300: .hhOrange300,
        color500: .hhOrange500, color600: .hhOrange600)
    case "lg":
      return TeamPrimaryPalette(
        color100: .lgRed100, color200: .lgRed200, color300: .lgRed300, color500: .lgRed500,
        color600: .lgRed600)
    case "lt":
      return TeamPrimaryPalette(
        color100: .ltNavy100, color200: .ltNavy200, color300: .ltNavy300, color500: .ltNavy500,
        color600: .ltNavy600)
    case "ss":
      return TeamPrimaryPalette(
        color100: .ssBlue100, color200: .ssBlue200, color300: .ssBlue300, color500: .ssBlue500,
        color600: .ssBlue600)
    case "nc":
      return TeamPrimaryPalette(
        color100: .ncDeepblue100, color200: .ncDeepblue200, color300: .ncDeepblue300,
        color500: .ncDeepblue500, color600: .ncDeepblue600)
    case "kt":
      return TeamPrimaryPalette(
        color100: .ktJetblack100, color200: .ktJetblack200, color300: .ktJetblack300,
        color500: .ktJetblack500, color600: .ktJetblack600)
    case "ssg":
      return TeamPrimaryPalette(
        color100: .ssgDeepred100, color200: .ssgDeepred200, color300: .ssgDeepred300,
        color500: .ssgDeepred500, color600: .ssgDeepred600)
    case "ds":
      return TeamPrimaryPalette(
        color100: .dsMidnight100, color200: .dsMidnight200, color300: .dsMidnight300,
        color500: .dsMidnight500, color600: .dsMidnight600)
    case "kw":
      return TeamPrimaryPalette(
        color100: .kwBurgundy100, color200: .kwBurgundy200, color300: .kwBurgundy300,
        color500: .kwBurgundy500, color600: .kwBurgundy600)
    case "kia":
      return TeamPrimaryPalette(
        color100: .kiaScarlet100, color200: .kiaScarlet200, color300: .kiaScarlet300,
        color500: .kiaScarlet500, color600: .kiaScarlet600)
    default:
      return TeamPrimaryPalette(
        color100: .clear, color200: .clear, color300: .clear, color500: .clear, color600: .clear)
    }
  }

  static func teamSecondaryPalette(for assetPrefix: String) -> TeamSecondaryPalette {
    switch assetPrefix {
    case "hh":
      return TeamSecondaryPalette(
        color100: .hhOrange100, color200: .hhOrange200, color300: .hhOrange300,
        color500: .hhOrange500, color600: .hhOrange600)
    case "lg":
      return TeamSecondaryPalette(
        color100: .lgRed100, color200: .lgRed200, color300: .lgRed300, color500: .lgRed500,
        color600: .lgRed600)
    case "lt":
      return TeamSecondaryPalette(
        color100: .ltRed100, color200: .ltRed200, color300: .ltRed300, color500: .ltRed500,
        color600: .ltRed600)
    case "ss":
      return TeamSecondaryPalette(
        color100: .ssBlue100, color200: .ssBlue200, color300: .ssBlue300, color500: .ssBlue500,
        color600: .ssBlue600)
    case "nc":
      return TeamSecondaryPalette(
        color100: .ncGold100, color200: .ncGold200, color300: .ncGold300, color500: .ncGold500,
        color600: .ncGold600)
    case "kt":
      return TeamSecondaryPalette(
        color100: .ktRed100, color200: .ktRed200, color300: .ktRed300, color500: .ktRed500,
        color600: .ktRed600)
    case "ssg":
      return TeamSecondaryPalette(
        color100: .ssgDeepred100, color200: .ssgDeepred200, color300: .ssgDeepred300,
        color500: .ssgDeepred500, color600: .ssgDeepred600)
    case "ds":
      return TeamSecondaryPalette(
        color100: .dsRed100, color200: .dsRed200, color300: .dsRed300, color500: .dsRed500,
        color600: .dsRed600)
    case "kw":
      return TeamSecondaryPalette(
        color100: .kwBurgundy100, color200: .kwBurgundy200, color300: .kwBurgundy300,
        color500: .kwBurgundy500, color600: .kwBurgundy600)
    case "kia":
      return TeamSecondaryPalette(
        color100: .kiaScarlet100, color200: .kiaScarlet200, color300: .kiaScarlet300,
        color500: .kiaScarlet500, color600: .kiaScarlet600)
    default:
      return TeamSecondaryPalette(
        color100: .clear, color200: .clear, color300: .clear, color500: .clear, color600: .clear)
    }
  }

  static func teamColors(for assetPrefix: String) -> TeamColorSet {
    switch assetPrefix {
    case "hh":
      return TeamColorSet(primary: .hanwhaPrimary, secondary: .hanwhaSecondary)
    case "lg":
      return TeamColorSet(primary: .lgPrimary, secondary: .lgSecondary)
    case "lt":
      return TeamColorSet(primary: .lottePrimary, secondary: .lotteSecondary)
    case "ss":
      return TeamColorSet(primary: .samsungPrimary, secondary: .samsungSecondary)
    case "nc":
      return TeamColorSet(primary: .ncPrimary, secondary: .ncSecondary)
    case "kt":
      return TeamColorSet(primary: .ktPrimary, secondary: .ktSecondary)
    case "ssg":
      return TeamColorSet(primary: .ssgPrimary, secondary: .ssgSecondary)
    case "ds":
      return TeamColorSet(primary: .doosanPrimary, secondary: .doosanSecondary)
    case "kw":
      return TeamColorSet(primary: .kiwoomPrimary, secondary: .kiwoomSecondary)
    case "kia":
      return TeamColorSet(primary: .kiaPrimary, secondary: .kiaSecondary)
    default:
      return TeamColorSet(primary: .appPrimary, secondary: .appSecondary)
    }
  }
}
