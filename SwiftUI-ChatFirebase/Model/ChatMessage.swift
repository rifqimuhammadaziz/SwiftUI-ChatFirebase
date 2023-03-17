//
//  ChatMessage.swift
//  SwiftUI-ChatFirebase
//
//  Created by Rifqi Muhammad Aziz on 17/03/23.
//

import Foundation

struct ChatMessage: Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstant.fromId] as? String ?? ""
        self.toId = data[FirebaseConstant.toId] as? String ?? ""
        self.text = data[FirebaseConstant.text] as? String ?? ""
    }
}
