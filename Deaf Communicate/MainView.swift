//
//  MainView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/14/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject public var mainViewModel = MainViewModel()
    @State private var freshLaunch = true
    @Environment(\.colorScheme) var colorScheme
    @FocusState var textEditorFocused : Bool
    
    //Localized variables (for multi language support)
    let copyButton : LocalizedStringKey = "Copy Button"
    let deleteButton : LocalizedStringKey = "Delete Button"
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                GeometryReader{
                    
                    geometry in
                    
                    VStack{
                        
                        Text(mainViewModel.statement == "" ? mainViewModel.instructionMessageOne : "")
                            .font(.system(size:18))
                            .padding([.top, .bottom])
                            .multilineTextAlignment(.center)
                        
                        ScrollView{
                            
                            TextEditor(text: $mainViewModel.statement)
                                .focused($textEditorFocused)
                                .font(Font.custom(mainViewModel.fontStyle, size:mainViewModel.fontSize))
                                .autocorrectionDisabled(true)
                                .foregroundColor(mainViewModel.isCustomFontColor == false ? colorScheme == .dark ? Color.white : Color.black : mainViewModel.fontColor)
                                .frame(height: textEditorFocused == true ? geometry.size.height*0.8 : geometry.size.height*0.85)
                                .scrollContentBackground(.hidden)
                                .background(.gray.opacity(0.3))
                                .cornerRadius(8)
                            
                        }
                        .scrollDismissesKeyboard(.interactively)
                        
                    }
                    .toolbar{
                        
                        ToolbarItem(placement: .topBarLeading){
                            
                            Menu{
                                
                                Button{
                                    
                                    mainViewModel.copyTextToClipboard()
                                    
                                }label:{
                                    
                                    Label(copyButton, systemImage: "doc.on.doc")
                                }
                                
                                
                                Button(role: .destructive, action: {mainViewModel.deleteText()}){
                                    Label(deleteButton, systemImage: "trash")
                                }
                                
                            }label:{
                                Label("Text Actions", systemImage: "ellipsis.circle")
                            }
                            
                        }
                        
                        ToolbarItem(placement: .topBarLeading){
                            
                            Button{
                                
                                DispatchQueue.main.async{
                                    mainViewModel.showHistorySheet = true
                                }
                                
                            }label:{
                                Label("", systemImage: "clock.arrow.circlepath")
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing){
                            NavigationLink(destination: SettingsView().environmentObject(mainViewModel)){
                                Image(systemName: "gear")
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing){
                            NavigationLink(destination: FeedbackView()){
                                Image(systemName: "exclamationmark.bubble")
                            }
                        }
                        
                    }
                    
                }
                .onAppear(){
                    if freshLaunch{
                        mainViewModel.configureUserDefaults()
                        freshLaunch = false
                    }
                }
                
                if let notificationSymbol = mainViewModel.notificationSymbol, let notificationText = mainViewModel.notificationText, mainViewModel.showNotification{
                    NotificationView(symbol: notificationSymbol, text: notificationText)
                }
                
            }
            .sheet(isPresented: $mainViewModel.showHistorySheet, onDismiss: {}, content: {
                
                TextHistoryView(showHistorySheet: $mainViewModel.showHistorySheet).environmentObject(mainViewModel)
                
            })
            
        }
    }
}
