//
//  ContentView.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 6/22/22.
//

import SwiftUI
import CoreData


struct ContentView: View
{
    //General variables
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var statementObject = StatementObject()
    @StateObject private var history = History()
    
    //Localized variables (for multi language support)
    let resourcesSideBar : LocalizedStringKey = "Resources Side Bar"
    let textBoardNavLink: LocalizedStringKey = "Text Board Nav Link"
    let pastStatementsNavLink : LocalizedStringKey = "Past Statements Nav Link"
    let settingsNavLink : LocalizedStringKey = "Settings Nav Link"
    let feedbackNavLink : LocalizedStringKey = "Feedback Nav Link"
    
    var body: some View
    {
        
       
        NavigationView
        {
            
            List()
            {
                
                NavigationLink(destination: TextEditorView().environmentObject(statementObject).environmentObject(history))
                {
                    Image(systemName: "text.alignleft")
                    Text(textBoardNavLink)
                }
                
                NavigationLink(destination: PastStatementsView().environmentObject(history).environmentObject(statementObject))
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


class StatementObject: ObservableObject
{
    @Published var statement = ""
}

class History: ObservableObject
{
    @Published var statementHistory: [String] = []
    @Published var noPastStatements = true
    @Published var showPastStatementsSheet : Bool = false
}

