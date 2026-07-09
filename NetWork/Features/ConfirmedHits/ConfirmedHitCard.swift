//
//  ConfirmedHitCard.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/8/26.
//

import SwiftUI
import Kingfisher
import MapKit

struct ConfirmedHitCard: View {
    let confirmedHit: ConfirmedHit

    @State private var isExpanded = false

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d 'at' h:mm a"
        return formatter.string(from: confirmedHit.date)
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    KFImage(URL(string: confirmedHit.profilePictureURL ?? ""))
                        .placeholder {
                        Image(systemName: "person")
                            .foregroundColor(Color.brandBlue)
                            .font(.system(size: 25))
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.brandBlue, lineWidth: 2))
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text(confirmedHit.posterName)
                            .font(.footnote)
                            .bold()
                        if let utr = confirmedHit.posterUTR {
                            Text("UTR: \(utr, specifier: "%.1f")")
                                .font(.footnote)
                        }
                        if let usta = confirmedHit.posterUSTA {
                            Text("USTA: \(usta, specifier: "%.1f")")
                                .font(.footnote)
                        }
                    }
                    
                    
                    Spacer()
                    AvatarClusterView(postID: confirmedHit.id, isOwner: false)
                    Spacer()
                }

                Divider()

                HStack {
                    Text(formattedDate)
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text(confirmedHit.location)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    if let lat = confirmedHit.latitude, let long = confirmedHit.longitude {
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        Map(position: .constant(.region(MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))) {
                                Marker(confirmedHit.location, coordinate: coordinate)
                            }
                            .frame(height: 150)
                            .cornerRadius(10)
                                                                           
                    }
                    
                    if isExpanded {
                        Text(confirmedHit.extraInfo)
                            .font(.body)
                    }
                }

                if !confirmedHit.extraInfo.isEmpty {
                    HStack {
                        Spacer()
                        Button(action: { isExpanded.toggle() }) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 8)
            .animation(.easeInOut(duration: 0.2), value: isExpanded)
        }
    }
}

#Preview {
    let hit = ConfirmedHit(
        id: "preview",
        posterName: "Rezka Yuspi",
        posterUTR: 8.5,
        posterUSTA: 4.5,
        location: "Griffith Park Tennis Courts",
        date: Date(),
        extraInfo: "Looking for a competitive rally session.",
        numberOfPeople: 2,
        profilePictureURL: nil,
        latitude: 34.1365,
        longitude: -118.2942
    )
    ConfirmedHitCard(confirmedHit: hit)
}
