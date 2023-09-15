//
//  NotificationView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/8/23.
//

import SwiftUI

struct NotificationView: View {
    
    public var symbol: String
    public var text: LocalizedStringKey
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .frame(width:150, height:100)
                .foregroundColor(.white)
                .backgroundStyle(.thinMaterial)
                .cornerRadius(8)
            VStack{
                Image(systemName: symbol)
                Text(text)
            }
        }
        .transition(.push(from: .top))
    }
}
