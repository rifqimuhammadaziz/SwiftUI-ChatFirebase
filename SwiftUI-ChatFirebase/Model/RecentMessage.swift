//
//  RecentMessage.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 17/03/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
}
