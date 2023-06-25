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
    @EnvironmentObject private var deafCommunicateModel: DeafCommunicateModel
    @Environment(\.dismiss) private var dismiss
    @State var showNoPastStatementsAlert = false
    
    //Localized variables (for multi language support)
    let pastStatementsViewInstructions : LocalizedStringKey = "Past Statements View Instructions"
    let navigationTitleFour : LocalizedStringKey = "Navigation Title Four"
    
    let noPastStatementsAlertTitle: LocalizedStringKey = "No Past Statements Alert Title"
    let noPastStatementsAlertMessage: LocalizedStringKey = "No Past Statements Alert Message"
    
        
    var body: some View{
        
        VStack{
            
            if !(deafCommunicateModel.statementHistory.isEmpty){
                
                
                Text(pastStatementsViewInstructions)
                    .font(.system(size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                
                List(){
                    
                    ForEach(deafCommunicateModel.statementHistory.reversed(), id:\.self){
                        
                        pastStatement in
                        
                        Button(){
                            
                            deafCommunicateModel.statement = pastStatement
                        }
                        label:{
                            
                            Text(pastStatement)
                        }
                        
                    }
                }
                .navigationTitle(navigationTitleFour)
                .listStyle(DefaultListStyle())
            }
                
        }
        .alert(noPastStatementsAlertTitle, isPresented: $showNoPastStatementsAlert, actions: {
            
            Button(action: {
                
                dismiss()
                
            }, label: {
                
                Text("OK")
            })
            
        }, message: {
            
            Text(noPastStatementsAlertMessage)
            
        })
        .onAppear{
            
            if deafCommunicateModel.statementHistory.count == 0{
                
                showNoPastStatementsAlert = true
                
            }else{
                
                showNoPastStatementsAlert = false
            }
            
        }
    }
    
}

struct PastStatementsView_Previews: PreviewProvider {
    static var previews: some View {
        PastStatementsView()
    }
}
