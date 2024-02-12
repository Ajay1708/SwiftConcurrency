//
//  DoTryCatchThrowsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 06/02/24.
//

import SwiftUI

struct DoTryCatchThrowsBootcamp: View {
    @StateObject var viewModel = DoTryCatchThrowsViewModel(manager: DoTryCatchThrowsManager())
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoTryCatchThrowsBootcamp()
}
