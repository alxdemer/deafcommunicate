//
//  HistoryView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/26/22.
//

import SwiftUI

struct TextHistoryView: View{
    
    //General variables
    @Binding var showHistorySheet: Bool
    @EnvironmentObject private var deafCommunicateModel: MainViewModel
    //@Environment(\.dismiss) private var dismiss
    @State var showNoTextHistoryAlert = false
    
    //Localized variables (for multi language support)
    let textHistoryViewTitle : LocalizedStringKey = "Text History View Title"
    let textHistoryViewInstructions : LocalizedStringKey = "Text History View Instructions"
    let noTextHistoryAlertTitle: LocalizedStringKey = "No Text History Alert Title"
    let noTextHistoryAlertMessage: LocalizedStringKey = "No Text History Alert Message"
    
    var body: some View{
        
        VStack{
            
            if !(deafCommunicateModel.statementHistory.isEmpty){
                
                Text(textHistoryViewTitle)
                    .font(.title3)
                    .bold()
                    .padding()
                
                Text(textHistoryViewInstructions)
                    .font(.system(size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                
                List(){
                    
                    ForEach(deafCommunicateModel.statementHistory.reversed(), id:\.self){
                        
                        pastStatement in
                        
                        Button(){
                            
                            deafCommunicateModel.statement = pastStatement
                            showHistorySheet = false
                        }
                        label:{
                            
                            Text(pastStatement)
                        }
                        
                    }
                }
                .listStyle(DefaultListStyle())
            }
                
        }
        .alert(noTextHistoryAlertTitle, isPresented: $showNoTextHistoryAlert, actions: {
            
            Button(action: {
                
                showHistorySheet = false
                
            }, label: {
                
                Text("OK")
            })
            
        }, message: {
            
            Text(noTextHistoryAlertMessage)
            
        })
        .onAppear{
            
            if deafCommunicateModel.statementHistory.count == 0{
                
                showNoTextHistoryAlert = true
                
            }else{
                showNoTextHistoryAlert = false
                
            }
            
        }
    }
    
}
