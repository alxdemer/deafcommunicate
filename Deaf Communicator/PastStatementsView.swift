//
//  StatementHistoryView.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 6/26/22.
//

import SwiftUI

struct PastStatementsView: View
{
    //General variables
    @EnvironmentObject private var history: History
    @EnvironmentObject private var statementObject: StatementObject
    @Environment(\.presentationMode) var presentationMode
    @State var test = true
    
    //Localized variables (for multi language support)
    let pastStatementsViewInstructions : LocalizedStringKey = "Past Statements View Instructions"
    let navigationTitleFour : LocalizedStringKey = "Navigation Title Four"
    let noPastStatementsMessage: LocalizedStringKey = "No Past Statements Message"
    
        
    var body: some View
    {
        VStack
        {
                
            if (history.statementHistory.count == 0)
            {
                
                Text(noPastStatementsMessage)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .navigationTitle(navigationTitleFour)
            }
            else
            {
                Text(pastStatementsViewInstructions)
                    .font(.system(size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                
                List()
                {
                    ForEach(history.statementHistory.reversed(), id:\.self)
                    {
                        pastStatement in
                        
                        Button()
                        {
                            statementObject.statement = pastStatement
                            history.showPastStatementsSheet = false
                        }
                        label:
                        {
                            Text(pastStatement)
                        }
                        
                    }
                }
                .navigationTitle(navigationTitleFour)
                .listStyle(DefaultListStyle())
            }
                
        }
        
    }
    
}

struct PastStatementsView_Previews: PreviewProvider {
    static var previews: some View {
        PastStatementsView()
    }
}
