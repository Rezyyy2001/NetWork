//
//  EditServiceSection.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/15/26.
//

import SwiftUI

public struct EditServiceSection: View {
    @ObservedObject var viewModel: EditServiceViewModel
    
    public var body: some View {
        Section {
            Button(action: {
                withAnimation {
                    viewModel.isEditingService.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "person.text.rectangle")
                        .foregroundColor(.blue)
                    Text("Edit Services")
                        .foregroundColor(.blue)
                    Spacer()
                    Image(systemName: viewModel.isEditingService ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            
            if viewModel.isEditingService {
                HStack {
                    ForEach(ServiceType.allCases, id: \.self) { type in
                        Button {
                            viewModel.selectedServiceType = type
                            viewModel.serviceType = type
                            Task { await viewModel.fetchUserCard(for: type) }
                        } label: {
                            VStack {
                                Image(systemName: type.icon)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color.brandBlue)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(viewModel.selectedServiceType == type ? Color.yellow : Color.clear, lineWidth: 2)
                                    )
                                Text(type.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.plain)
                    }
                }
                if viewModel.selectedServiceType != nil {
                    // About
                    Text("About")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    CustomTextbox(
                        text: $viewModel.description,
                        placeholder: "Give us some background about your service?",
                        characterLimit: 400
                    )
                    
                    // Location & pricing
                    Text("Details")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.brandBlue)
                        
                        TextField("City", text: $viewModel.city)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.brandBlue)
                        TextField("Price per hour", value: $viewModel.pricing, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                                            
                    // Contact
                    Text("Contact")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.brandBlue)
                        TextField("Email", text: $viewModel.email)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.brandBlue)
                        TextField("Mobile", text: $viewModel.phoneNumber)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    HStack {
                        Image(systemName: "camera")
                            .foregroundColor(.brandBlue)
                        TextField("Instagram", text: $viewModel.insta)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    HStack {
                        Toggle("", isOn: $viewModel.isActive)
                            .labelsHidden()
                        Text("Active")
                        Spacer()
                        Button("Save") {
                            Task { await viewModel.saveBusinessCard() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
        }
    }
}
