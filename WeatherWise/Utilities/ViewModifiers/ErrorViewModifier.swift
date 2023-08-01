//
//  ErrorViewModifier.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 01.08.2023.
//

import SwiftUI

struct ErrorModifier: ViewModifier {
    
    // MARK: - Properties
    
    @Binding var errorTitle: String?
    @State private var showAlert: Bool = false
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        return content
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(errorTitle ?? ""),
                    dismissButton: .default(Text("OK")) { errorTitle = nil }
                )
            }
            .onReceive(errorTitle.publisher) { _ in
                if errorTitle != nil { showAlert = true }
            }
    }
}

extension View {
    /// Custom  error listener modifier
    func addErrorListener(_ error: Binding<String?>) -> some View {
        self.modifier(ErrorModifier(errorTitle: error))
    }
}
