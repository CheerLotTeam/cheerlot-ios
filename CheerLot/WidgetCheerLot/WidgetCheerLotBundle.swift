//
//  WidgetCheerLotBundle.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 2/10/26.
//

import WidgetKit
import SwiftUI

@main
struct WidgetCheerLotBundle: WidgetBundle {
    var body: some Widget {
        WidgetCheerLot()
        WidgetCheerLotControl()
        WidgetCheerLotLiveActivity()
    }
}
