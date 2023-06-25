//
//  Deaf_CommunicatorApp.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 6/22/22.
//

import SwiftUI

@main
struct DeafCommunicateApp: App {
    
    //General variables
    @StateObject private var deafCommunicateModel = DeafCommunicateModel()
    
    //Localized variables (for multi language support)
    let resourcesSideBar : LocalizedStringKey = "Resources Side Bar"
    let textBoardNavLink: LocalizedStringKey = "Text Board Nav Link"
    let pastStatementsNavLink : LocalizedStringKey = "Past Statements Nav Link"
    let settingsNavLink : LocalizedStringKey = "Settings Nav Link"
    let feedbackNavLink : LocalizedStringKey = "Feedback Nav Link"

    var body: some Scene {
        
        WindowGroup
        {
            
            NavigationView
            {
                
                List()
                {
                    
                    NavigationLink(destination: TextBoardView().environmentObject(deafCommunicateModel))
                    {
                        Image(systemName: "text.alignleft")
                        Text(textBoardNavLink)
                    }
                    
                    NavigationLink(destination: PastStatementsView().environmentObject(deafCommunicateModel))
                    {
                        Image(systemName: "text.book.closed")
                        Text(pastStatementsNavLink)
                    }
                    
                    NavigationLink(destination:SettingsView())
                    {
                        Image(systemName: "gear")
                        Text(settingsNavLink)
                    }
                    
                    NavigationLink(destination:FeedbackView())
                    {
                        Image(systemName: "bubble.left.and.exclamationmark.bubble.right")
                        Text(feedbackNavLink)
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle(resourcesSideBar)
                
                WelcomeView()
                
            }
                
            
        }

    }
}
