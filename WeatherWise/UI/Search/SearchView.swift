//
//  SearchView.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 28.07.2023.
//

import SwiftUI
import MapKit

struct SearchView: View {
    
    private struct Const {
        static let imageSize = 28.0
        static let padding = 32.0
        static let emptyTopPadding = 96.0
        static let cornerRadius = 16.0
        static let textVerticalPadding = 12.0
    }

    // MARK: - Properties
    
    var onSelect: (WeatherLocation) -> Void
    
    // Private properties
    @ObservedObject private var viewModel = ModuleFactory.ViewModel.searchViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            TextField("", text: $viewModel.searchText, prompt: Text(Strings.Search.searchText))
                .padding(.horizontal)
                .padding(.vertical, Const.textVerticalPadding)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(Const.cornerRadius)
                .padding(Const.padding)
            
            content
            
            Spacer()
        }
        .navigationTitle(Strings.Search.title)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.chevronLeft
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .bold()
                        .frame(width: Const.imageSize, height: Const.imageSize)
                }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.foundWeatherObjects.isEmpty {
            emptyStateView
                .padding(.top, Const.emptyTopPadding)
        } else {
            locationsListView
        }
    }
    
    private var locationsListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.foundWeatherObjects, id: \.location.id) { weatherObject in
                    VStack(alignment: .leading) {
                        Text(weatherObject.location.title)
                        
                        Text(weatherObject.description)
                        
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .frame(height: 1)
                    }
                    .background(.white)
                    .onTapGesture {
                        self.onSelect(weatherObject.location)
                        viewModel.searchText = ""
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, Const.padding)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var emptyStateView: some View {
        Text(Strings.Search.empty)
            .foregroundColor(.gray)
            .font(.system(size: 28))
            .bold()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView() { _ in }
    }
}
