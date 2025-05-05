//
//  ContentView.swift
//  ListedUserApp
//
//  Created by Vidhyasagar on 05/05/25.
//

import SwiftUI

struct ListView: View {
    
    @StateObject var listViewModel = ListViewModel(apiService: .init())
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Users")
                Spacer()
                Button {
                    listViewModel.shouldShowCityDropdown(true)
                } label: {
                    HStack(spacing: 3) {
                        Text(listViewModel.state.selectedCity)
                        Image(systemName: "chevron.down")
                            .frame(width: 12, height: 12)
                    }
                    .padding(5)
                    .foregroundColor(Color.blue)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
            content
        }
        .task {
            await listViewModel.fetchUsers()
        }
        .overlay(content: {
            if listViewModel.state.showCityDropdown {
                HStack {
                  Spacer()
                    VStack {
                        ScrollView {
                            LazyVStack{
                                ForEach(listViewModel.state.cities, id: \.self) { city in
                                    Button {
                                        listViewModel.didSelectCity(city)
                                    } label: {
                                        HStack {
                                            Spacer()
                                            Text(city)
                                            Spacer()
                                        }
                                            .padding(5)
                                            .foregroundColor(listViewModel.state.selectedCity == city ? .blue : .black)
                                            .background {
                                                if listViewModel.state.selectedCity == city {
                                                    Color.blue.opacity(0.2)
                                                } else {
                                                    Color.white
                                                }
                                            }
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal, 6)
                        }
                        Spacer()
                    }
                    .background(.white)
                    .frame(width: UIScreen.main.bounds.width/2)
                }
                .background(Color.black.opacity(0.2).edgesIgnoringSafeArea(.all))
            }
        })
        
    }
    
    var content: some View {
        ScrollView {
            LazyVStack {
                ForEach(users, id: \.id) { user in
                    HStack {
                        Text(user.name ?? String())
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 18)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    var users: UserListResponse {
        listViewModel.state.selectedCity == "All"
        ?
        listViewModel.state.users
        :
        listViewModel.state.users.filter { $0.address?.city == listViewModel.state.selectedCity }
    }
}
