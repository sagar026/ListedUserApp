//
//  ListViewModel.swift
//  ListedUserApp
//
//  Created by Vidhyasagar on 05/05/25.
//

import SwiftUI

struct ListViewState {
    var users: UserListResponse = []
    var error: ServiceError? = .none
    var showCityDropdown: Bool = false
    var selectedCity: String = "All"
    var cities: [String] = []
}

class ListViewModel: ObservableObject {
    @Published var state: ListViewState = .init()
    
    var apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
}

//MARK: State Changes
extension ListViewModel {
    
    func updateUsers(_ users: UserListResponse) {
        state.users = users
        state.cities.append("All")
        state.cities = state.cities + state.users.flatMap({ $0.address?.city })
    }
    
    func showError(_ error: ServiceError?) {
        state.error = error
    }
    
    func shouldShowCityDropdown(_ value: Bool) {
        withAnimation {
            state.showCityDropdown = value
        }
    }
    
    func didSelectCity(_ city: String) {
        state.selectedCity = city
        shouldShowCityDropdown(false)
    }
}

//MARK: API Calls
extension ListViewModel {
    @MainActor
    func fetchUsers() async {
        let request = GetUsersRequest()
        do {
            let data = try await apiService.request(request: request)
            updateUsers(data)
        } catch {
            if let error = error as? ServiceError {
                showError(error)
            }
        }
    }
}
