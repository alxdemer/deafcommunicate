//
//  MainView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/14/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject public var model = MainViewModel()
    @State private var freshLaunch = true
    @Environment(\.colorScheme) var colorScheme
    @FocusState var textEditorFocused : Bool
    
    //Localized variables (for multi language support)
    let copyButton : LocalizedStringKey = "Copy Button"
    let saveToTextHistory : LocalizedStringKey = "Save To History Button"
    let deleteButton : LocalizedStringKey = "Delete Button"
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                GeometryReader{
                    
                    geometry in
                    
                    VStack{
                        
                        Text(model.text == "" ? model.instructionMessageOne : "")
                            .font(.system(size:18))
                            .padding([.top, .bottom])
                            .multilineTextAlignment(.center)
                        
                        ScrollView{
                            
                            TextEditor(text: $model.text)
                                .focused($textEditorFocused)
                                .font(Font.custom(model.fontStyle, size:model.fontSize))
                                .autocorrectionDisabled(true)
                                .foregroundColor(model.isCustomFontColor == false ? colorScheme == .dark ? Color.white : Color.black : model.fontColor)
                                .frame(height: textEditorFocused == true ? geometry.size.height*0.8 : geometry.size.height*0.85)
                                .scrollContentBackground(.hidden)
                                .background(.gray.opacity(0.3))
                                .cornerRadius(8)
                            
                        }
                        .scrollDismissesKeyboard(.interactively)
                        
                        if textEditorFocused == false{
                            
                            Button{
                                model.isRecording ? model.stopRecording() : model.startRecording()
                            }label:{
                                Image(model.isRecording ? "MicOnIcon" : "MicOffIcon")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                
                            }
                            
                        }
                        
                    }
                    .toolbar{
                        
                        ToolbarItem(placement: .topBarLeading){
                            
                            Menu{
                                
                                Button{
                                    model.copyTextToClipboard()
                                }label:{
                                    Label(copyButton, systemImage: "doc.on.doc")
                                }
                                
                                Button{
                                    model.saveTextToHistory()
                                } label:{
                                    Label(saveToTextHistory, systemImage: "square.and.arrow.down")
                                }
                                
                                Button(role: .destructive){
                                    model.deleteText()
                                } label:{
                                    Label(deleteButton, systemImage: "trash")
                                }
                                
                            }label:{
                                Image("AdditionalOptionsIcon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            
                        }
                        
                        ToolbarItem(placement: .topBarLeading){
                            
                            Button{
                                Task.init(priority: .userInitiated){
                                    model.showTextHistory = true
                                }
                            }label:{
                                Image("TextHistoryIcon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing){
                            NavigationLink(destination: SettingsView().environmentObject(model)){
                                Image("SettingsIcon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing){
                            NavigationLink(destination: FeedbackView()){
                                Image("FeedbackIcon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                    }
                    
                }
                .onAppear(){
                    if freshLaunch{
                        model.configureUserDefaults()
                        freshLaunch = false
                    }
                    
                    model.requestPermission()
                }
                
                if let notificationSymbol = model.notificationSymbol, let notificationText = model.notificationText, model.showNotification{
                    NotificationView(symbol: notificationSymbol, text: notificationText)
                }
                
            }
            .sheet(isPresented: $model.showTextHistory, onDismiss: {}, content: {
                
                TextHistoryView(showTextHistory: $model.showTextHistory).environmentObject(model)
                
            })
            
        }
    }
}
