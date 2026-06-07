//
//  FilterView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/6/26.
//

import SwiftUI

struct FilterView: View {

    @Binding var isNewest: Bool
    @Binding var numberOfPeople: Int
    @Binding var isFriends: Bool
    
    var body: some View {
        VStack {
            Picker("Order", selection: $isNewest) {
                Text("Newest").tag(true)
                Text("Oldest").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker("Players", selection: $numberOfPeople) {
                Text("Any").tag(0)
                Text("Singles").tag(1)
                Text("Doubles").tag(3)
                Text("4+").tag(4)
            }
            .pickerStyle(.segmented)
            
            Picker("Visibility", selection: $isFriends) {
                Text("Friends").tag(true)
                Text("Public").tag(false)
            }
            .pickerStyle(.segmented)
        }
    }
}
#Preview {
    FilterView(isNewest: .constant(true),
               numberOfPeople: .constant(0),
               isFriends: .constant(true))
}
