//
//  ContentView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 9/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoginSignupView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                Button(action: { showLoginSignupView = true}) {
                    tennisCourt()
                        .stroke(Color.white, lineWidth: 4)
                        .background(Color(red: 30/255, green: 143/255, blue: 213/255))
                        .frame(width: 300, height: 650)
                }
                VStack {
                    Text("Welcome \nNetWork")
                        .font(.custom("Baskerville", size: 50))
                        .fontWeight(.semibold)
                        .position(x: 200, y: 275)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
         
            }
            .navigationDestination(isPresented: $showLoginSignupView) {
                LoginSignupView()
            }
        }
    }
}

struct tennisCourt: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let serviceLineDepth: CGFloat = 150
        let singlesSideline: CGFloat = 37.5
        let centerY = rect.midY
        
        // Outer rectangle
        path.addRect(rect)
        
        //center line (Net)
        path.move(to: CGPoint(
            x: rect.minX,
            y: centerY))
        path.addLine(to: CGPoint(
            x: rect.maxX,
            y: centerY))
        
        //left singles sidelines
        path.move(to: CGPoint(
            x: rect.minX + singlesSideline,
            y: rect.maxY))
        path.addLine(to: CGPoint(
            x: singlesSideline,
            y: rect.minY))
        
        //right singles sideline
        path.move(to: CGPoint(
            x: rect.maxX - singlesSideline,
            y: rect.maxY))
        path.addLine(to: CGPoint(
            x: rect.maxX - singlesSideline,
            y: rect.minY))
        
        //service line top
        path.move(to: CGPoint(
            x: rect.minX + singlesSideline,
            y: rect.minY + serviceLineDepth))
        path.addLine(to: CGPoint(
            x: rect.maxX - singlesSideline,
            y: rect.minY + serviceLineDepth))
        
        //service line bottom
        path.move(to: CGPoint(
            x: rect.minX + singlesSideline,
            y: rect.maxY - serviceLineDepth))
        path.addLine(to: CGPoint(
            x: rect.maxX - singlesSideline,
            y: rect.maxY - serviceLineDepth))
        
        //T line
        path.move(to: CGPoint(
            x: rect.midX,
            y: rect.maxY - serviceLineDepth))
        path.addLine(to: CGPoint(
            x: rect.midX,
            y: rect.minY + serviceLineDepth))
        
        return path
    }
}





#Preview {
    ContentView()
}
