//
//  ChatUser.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 08/03/23.
//

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}
