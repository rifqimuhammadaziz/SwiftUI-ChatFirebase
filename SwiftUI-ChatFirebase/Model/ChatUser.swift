//
//  ChatUser.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 08/03/23.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? "Empty UID"
        self.email = data["email"] as? String ?? "Empty Email"
        self.profileImageUrl = data["profileImageUrl"] as? String ?? "Empty Image"
    }
}
