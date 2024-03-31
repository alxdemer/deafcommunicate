//
//  TextHistoryContainer.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 3/30/24.
//

import Foundation

struct TextHistoryContainer: Identifiable, Hashable{
    var id = UUID()
    let text: String
    
    init(text: String) {
        self.text = text
    }
}
