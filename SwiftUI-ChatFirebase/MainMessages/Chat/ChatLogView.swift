//
//  ChatLogView.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 10/03/23.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @State var chatText = ""
    
    var body: some View {
        
        ZStack {
            messagesView
            
            VStack {
                Spacer()
                chatBottomBar
                    .background(Color.white)
            }
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
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
        .padding(.bottom, 65)
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            
            TextField("Description", text: $chatText)
            
            Button {
                
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
