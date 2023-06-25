//
//  TextEditorView.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 7/4/22.
//

import SwiftUI

struct TextBoardView: View
{
    
    //General Variables
    @ObservedObject var textBoardViewModel = TextBoardViewModel()
    @EnvironmentObject private var deafCommunicateModel: DeafCommunicateModel
    @Environment(\.colorScheme) var currentMode
    @FocusState private var isTextEditorFocused : Bool
    @State var showAlert : Bool = false
    @State var fontSize: Double = 50.0
    @State var fontStyle: String = "SF Pro Regular"
    @State var customFontColor: Color = Color.black
    @State var customColor: Bool = false
    
    
    var body: some View {
        
        GeometryReader{
            
            geometry in
            
                VStack{
                    
                    Text(deafCommunicateModel.statement == "" ? textBoardViewModel.instructionMessageOne : "")
                        .font(.system(size:20))
                        .padding(2)
                        .multilineTextAlignment(.center)
                    
                    if textBoardViewModel.notification != nil {
                        
                        Text(textBoardViewModel.notification)
                            .foregroundColor(Color.red)
                }
                    
                
                ScrollView{
                        
                    TextEditor(text: $deafCommunicateModel.statement)
                        .focused($isTextEditorFocused)
                        .font(Font.custom(fontStyle, size:fontSize))
                        .autocorrectionDisabled(true)
                        .foregroundColor(customColor == false ? currentMode == .dark ? Color.white : Color.black : customFontColor)
                        .frame(height: isTextEditorFocused == true ? geometry.size.height*0.8 : geometry.size.height*0.85)
                        .scrollContentBackground(.hidden)
                        .background(.gray.opacity(0.3))
                        .cornerRadius(8)
                    
                }
                .scrollDismissesKeyboard(.interactively)
                
            }
            .navigationTitle(Text(textBoardViewModel.navigationTitleOne))
            .toolbar{
            
                
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    Button{
                    
                        textBoardViewModel.deleteText(deafCommunicateModel: deafCommunicateModel)
                        
                    }label:{
                        
                        Image(systemName: "trash")
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    Button{
                        
                        textBoardViewModel.copyToClipboard(deafCommunicateModel: deafCommunicateModel)
                        
                    }label:{
                        
                        Image(systemName: "doc.on.doc")
                    }
                }
            }
            .onAppear
            {
                UITextView.appearance().backgroundColor = .clear
                
                if (UserDefaults.standard.object(forKey: "fontSize") == nil){
                    UserDefaults.standard.set(50.0, forKey: "fontSize")
                    
                    fontSize = (UserDefaults.standard.object(forKey: "fontSize") as? Double)!
                    
                }else{
                    
                    fontSize = (UserDefaults.standard.object(forKey: "fontSize") as? Double)!
                    
                }
                
                if (UserDefaults.standard.object(forKey: "fontStyle") == nil){
                    
                    UserDefaults.standard.set("SF Pro Regular", forKey: "fontStyle")
                    fontStyle = (UserDefaults.standard.object(forKey: "fontStyle") as? String)!
                    
                }else{
                    
                    fontStyle = (UserDefaults.standard.object(forKey: "fontStyle") as? String)!
                    
                }
                
                if (UserDefaults.standard.object(forKey: "customFontColor") == nil){
                    
                    UserDefaults.standard.set(1, forKey: "customFontColor")
                    let colorNum = UserDefaults.standard.object(forKey: "customFontColor") as? Int
                    customFontColor = textBoardViewModel.determineColor(colorNum: colorNum!)
                    
                }else{
                    
                    let colorNum = UserDefaults.standard.object(forKey: "customFontColor") as? Int
                    customFontColor = textBoardViewModel.determineColor(colorNum: colorNum!)
                }
                
                if (UserDefaults.standard.object(forKey: "customColor") == nil){
                    
                    UserDefaults.standard.set(false, forKey: "customColor")
                    customColor = (UserDefaults.standard.object(forKey: "customColor") as? Bool)!
                    
                }else{
                    
                    customColor = (UserDefaults.standard.object(forKey: "customColor") as? Bool)!
                    
                }
            }
        }
        
    }
    
    
}

