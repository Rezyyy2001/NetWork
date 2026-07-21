//
//  BusinessCardView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/19/26.
//

import SwiftUI

struct BusinessCardView: View {
    @StateObject private var viewModel = EditServiceViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.serviceType)")
            }
        }
    }
}
