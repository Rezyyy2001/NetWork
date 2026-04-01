//
//  CustomTabView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/14/24.
//
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int // controls which tab is clicked
    @Namespace private var animationNamespace // for tab switching animation
    
    let items: [(image: String, title: String)]
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .foregroundColor(Color(.secondarySystemBackground))
                .shadow(radius: 4)
            
            HStack (spacing: 10){
                ForEach(0..<items.count, id: \.self) { index in
                    Button {
                        tabSelection = index + 1
                    } label: {
                        VStack(spacing: 8) {
                            Spacer()
                            
                            Image(systemName: items[index].image)
                            
                            Text(items[index].title)
                            
                            if index + 1 == tabSelection {
                                Capsule()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 8)
                                    .foregroundColor(.blue)
                                    
                                    .matchedGeometryEffect(id: "SelectedTabId", in: animationNamespace)
                                    .offset(y: 3)

                            } else {
                                Capsule()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 8)
                                    .foregroundColor(.clear)
                                    .offset(y: 3)
                            }
                        }
                        .foregroundColor(index + 1 == tabSelection ? .blue : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 8)
                    }
                }
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
        .offset(y: items.count <= 2 ? 80 : 0)
        .frame(maxHeight: items.count > 2 ? .infinity : nil, alignment: .bottom)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1),
                  items: [
                    ("person", "Login"),
                    ("clipboard", "SignUp")
            
                ]
    )
        .padding(.vertical)
    
    CustomTabView(tabSelection: .constant(1),
                  items: [
                    ("figure.tennis", "Friends"),
                    ("globe", "Local"),
                    ("plus.app", "Post"),
                    ("hand.wave", "Seach"),
                    ("person", "Profile")
                ]
    )
        .padding(.vertical)
}
