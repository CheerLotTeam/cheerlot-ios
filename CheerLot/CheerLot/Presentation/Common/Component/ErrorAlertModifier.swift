//
//  ErrorAlertModifier.swift
//  CheerLot
//
//  Created by 이현주 on 3/17/26.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var errorMessage: String?
    
    func body(content: Content) -> some View {
        content
            .alert("오류", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("확인", role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                if let error = errorMessage {
                    Text(error)
                }
            }
    }
}

struct ErrorAlertWithRetryModifier: ViewModifier {
    @Binding var errorMessage: String?
    let onRetry: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .alert("오류", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("다시 시도") {
                    Task {
                        await onRetry()
                    }
                }
                Button("취소", role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                if let error = errorMessage {
                    Text(error)
                }
            }
    }
}


