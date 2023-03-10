//
//  MainMessagesView.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 07/03/23.
//

import SwiftUI
import SDWebImageSwiftUI

class MainMessageViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find Firebase UID"
            return
        }
        
        self.errorMessage = "\(uid)"
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to fetch current user: ", error)
                    return
                }
                
                self.errorMessage = "123"
                
                guard let data = snapshot?.data() else {
                    self.errorMessage = "No data found"
                    return
                }
                
                // map to model
                self.chatUser = .init(data: data)
            }
    }
    
    @Published var isUserCurrentlyLoggedOut = false
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct MainMessagesView: View {
    
    @State var shouldShowLogoutOptions = false
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject private var vm = MainMessageViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
//                Text("User: \(vm.chatUser?.uid ?? "")")
                customNavbar
                messagesView
                
                NavigationLink("sss", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .overlay(newMessageButton, alignment: .bottom)
            .toolbar(.hidden)
        }
    }
    
    // TOP NAVBAR
    private var customNavbar: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                let email = vm
                    .chatUser?.email
                    .replacingOccurrences(of: "@gmail.com", with: "") ?? "error username"
                
                Text(email)
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(Color.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
            
            Button {
                shouldShowLogoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogoutOptions) {
            .init(
                title: Text("Settings"),
                message: Text("Are you sure to Sign Out?"),
                buttons: [
                    .destructive(Text("Sign Out"), action: {
                        print("Sign Out Works!")
                        vm.handleSignOut()
                    }),
                    .cancel()
                ]
            )
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    NavigationLink {
                        Text("Destination Reach")
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                            
                            
                            VStack(alignment: .leading) {
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()
                            
                            Text("22d")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
    }
    
    @State var shouldShowNewMessageScreen = false
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            CreateNewMessageView(didSelectNewUser: { user in
                print(user.email)
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
            })
        }
    }
    
    @State var chatUser: ChatUser?
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    var body: some View {
        ScrollView {
            ForEach(0..<10) { num in
                Text("Fake Message")
            }
        }
        .navigationTitle(chatUser?.email ?? "")
//        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        
        MainMessagesView()
            .preferredColorScheme(.light)
    }
}
