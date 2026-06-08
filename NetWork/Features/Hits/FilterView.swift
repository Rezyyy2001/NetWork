//
//  FilterView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/6/26.
//

import SwiftUI
import MultiSlider

struct FilterView: View {

    @Binding var isNewest: Bool
    @Binding var numberOfPeople: Int
    @Binding var isFriends: Bool
    
    @Binding var utrRange: [CGFloat]
    @Binding var ustaRange: [CGFloat]
    
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
            
            VStack(spacing: 1) {
                HStack {
                    Text ("UTR  ")
                    MultiValueSlider(value: $utrRange, minimumValue: CGFloat(1), maximumValue: CGFloat(16), outerTrackColor: .lightGray)
                        .thumbTintColor(.systemBlue)
                        .orientation(.horizontal)
                        .valueLabelPosition(.topMargin)
                }
                
                HStack {
                    Text ("USTA")
                    MultiValueSlider(value: $ustaRange, minimumValue: CGFloat(1), maximumValue: CGFloat(7), outerTrackColor: .lightGray)
                        .thumbTintColor(.systemBlue)
                        .orientation(.horizontal)
                        .valueLabelPosition(.topMargin)
                }
            }
        }
        .padding(10)
    }
}
#Preview {
    Color.clear.sheet(isPresented: .constant(true)) {
        FilterView(isNewest: .constant(true),
                   numberOfPeople: .constant(0),
                   isFriends: .constant(true),
                   utrRange: .constant([CGFloat(1), CGFloat(16)]),
                   ustaRange: .constant([CGFloat(1), CGFloat(7)])
        )
        .presentationDetents([.fraction(0.35)])
    }
}
