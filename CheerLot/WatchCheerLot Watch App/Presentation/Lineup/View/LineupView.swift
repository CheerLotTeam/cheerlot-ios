//
//  LineupView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/18/26.
//

import SwiftUI

struct LineupView: View {
    @State private var viewModel: LineupViewModel
    
    init(viewModel: LineupViewModel) {
      _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.lineupMembers.isEmpty {
                    EmptyListView
                } else {
                    MemberListView
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Text(viewModel.teamName!)
                                    .font(.SB6)
                                    .foregroundStyle(viewModel.asset!.secondaryColor)
                            }
                        }
                }
            }
            .task {
                await viewModel.onAppear()
            }
            .toolbar(viewModel.isOnboardingPresented ? .hidden : .visible)
            .overlay {
                if viewModel.isOnboardingPresented {
                    WatchOnboardingSheetView {
                        viewModel.isOnboardingPresented = false
                    }
                }
            }
        }
    }
}

extension LineupView {
    private var MemberListView: some View {
        List {
          ForEach(viewModel.lineupMembers, id: \.id) {
            member in
            NavigationLink {
                LyricsView(members: viewModel.lineupMembers, initialMember: member, asset: viewModel.asset!)
            } label: {
                HStack(spacing: 6) {
                    if let battingOrder = member.battingOrder {
                        Text("\(battingOrder)")
                            .font(.SB6)
                    }
                    
                    Text(member.name)
                        .font(.SB7)
                }
                .padding(.leading, 7.5)
            }
          }
        }
    }
    
    private var EmptyListView: some View {
        ZStack {
            viewModel.asset?.bgGradient
                .opacity(0.2)
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 2) {
                Text("선수 명단이 없어요")
                    .font(.SB7)
                    .foregroundStyle(.grayWhite)
                
                Text("iPhone 앱을 새로고침해 주세요")
                    .font(.M6)
                    .foregroundStyle(.gray200)
            }
        }
    }
}
