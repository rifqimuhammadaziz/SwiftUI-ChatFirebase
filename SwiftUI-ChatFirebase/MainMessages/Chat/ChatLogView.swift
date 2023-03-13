//
//  ChatLogView.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 10/03/23.
//

import SwiftUI
import Firebase

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
    }
    
    func handleSend() {
        print(chatText)
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [
            "fromId": fromId,
            "toId": toId,
            "text": self.chatText,
            "timestamp": Timestamp()
        ] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore \(error)"
                return
            }
            print("Successfully saved current user sending message")
            self.chatText = ""
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore \(error)"
                return
            }
            print("Recipient success saved the message")
        }
        
    }
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ForEach(0..<10) { num in
                    HStack {
                        Spacer()
                        
                        HStack {
                            Text("Fake Message")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                }
                
                HStack {
                    Spacer()
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                chatBottomBar
                    .background(Color(.systemBackground).ignoresSafeArea())
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            
//            TextEditor(text: $vm.chatText)
//                .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            TextField("Desc", text: $vm.chatText)
            
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(30)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: [
                "uid": "K2aPNBSlGsOOGPu8rmcW6K4DAOj2",
                "email": "emailtesting1@gmail.com"
            ]))
        }
    }
}
