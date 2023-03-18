//
//  ChatMessage.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 17/03/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
