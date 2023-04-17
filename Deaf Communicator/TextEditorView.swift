//
//  TextEditorView.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 7/4/22.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct TextEditorView: View
{
    
    //General Variables
    @EnvironmentObject private var statementObject: StatementObject
    @EnvironmentObject private var history: History
    @Environment(\.colorScheme) var currentMode
    @FocusState private var isTextEditorFocused : Bool
    @State var notification: LocalizedStringKey = ""
    @State var showAlert : Bool = false
    @State var fontSize: Double = 50.0
    @State var fontStyle: String = "SF Pro Regular"
    @State var customFontColor: Color = Color.black
    @State var customColor: Bool = false
    
    //Localized variables (for multi language support)
    let instructionMessageOne:LocalizedStringKey = "Instruction Message One"
    let navigationTitleOne:LocalizedStringKey = "Navigation Title One"
    let textCopiedNotification: LocalizedStringKey = "Text Copied Notification"
    private let pasteboard = UIPasteboard.general
    
    
    init()
    {
        UITextView.appearance().backgroundColor = .clear
    }
     
    
    var body: some View {
        
        GeometryReader
        {
            geometry in
            
            VStack
            {
                Text(statementObject.statement == "" ? instructionMessageOne : "")
                    .font(.system(size:20))
                    .padding(2)
                    .multilineTextAlignment(.center)
                Text(notification)
                    .foregroundColor(Color.red)
            
                ScrollView
                {
                    if #available(iOS 16, *)
                    {
                        TextEditor(text: $statementObject.statement)
                            .focused($isTextEditorFocused)
                            .font(Font.custom(fontStyle, size:fontSize))
                            .autocorrectionDisabled(true)
                            .foregroundColor(customColor == false ? currentMode == .dark ? Color.white : Color.black : customFontColor)
                            .frame(height: isTextEditorFocused == true ? geometry.size.height*0.8 : geometry.size.height*0.85)
                            .scrollContentBackground(.hidden)
                            .background(.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    else
                    {
                        TextEditor(text: $statementObject.statement)
                            .focused($isTextEditorFocused)
                            .font(Font.custom(fontStyle, size:fontSize))
                            .autocorrectionDisabled(true)
                            .foregroundColor(customColor == false ? currentMode == .dark ? Color.white : Color.black : customFontColor)
                            .frame(height: isTextEditorFocused == true ? geometry.size.height*0.8 : geometry.size.height*0.85)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    
                }
                
            }
            .navigationTitle(Text(navigationTitleOne))
            
            .toolbar
            {
            
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button(action: deleteText)
                    {
                        Image(systemName: "trash")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button
                    {
                        copyToClipboard()
                    }
                    label:
                    {
                        Image(systemName: "doc.on.doc")
                    }
                }
            }
            
            .onTapGesture {
                hideKeyboard()
            }
            
            .onAppear(perform:{
                
                if (UserDefaults.standard.object(forKey: "fontSize") == nil)
                {
                    UserDefaults.standard.set(50.0, forKey: "fontSize")
                    fontSize = (UserDefaults.standard.object(forKey: "fontSize") as? Double)!
                }
                else
                {
                    fontSize = (UserDefaults.standard.object(forKey: "fontSize") as? Double)!
                }
                
                if (UserDefaults.standard.object(forKey: "fontStyle") == nil)
                {
                    UserDefaults.standard.set("SF Pro Regular", forKey: "fontStyle")
                    fontStyle = (UserDefaults.standard.object(forKey: "fontStyle") as? String)!
                }
                else
                {
                    fontStyle = (UserDefaults.standard.object(forKey: "fontStyle") as? String)!
                }
                
                if (UserDefaults.standard.object(forKey: "customFontColor") == nil)
                {
                    UserDefaults.standard.set(1, forKey: "customFontColor")
                    let colorNum = UserDefaults.standard.object(forKey: "customFontColor") as? Int
                    customFontColor = determineColor(colorNum: colorNum!)
                }
                else
                {
                    let colorNum = UserDefaults.standard.object(forKey: "customFontColor") as? Int
                    customFontColor = determineColor(colorNum: colorNum!)
                }
                
                if (UserDefaults.standard.object(forKey: "customColor") == nil)
                {
                    UserDefaults.standard.set(false, forKey: "customColor")
                    customColor = (UserDefaults.standard.object(forKey: "customColor") as? Bool)!
                }
                else
                {
                    customColor = (UserDefaults.standard.object(forKey: "customColor") as? Bool)!
                }
                
            })
        }
        
    }
    
    func determineColor(colorNum: Int) -> Color
    {
        if (colorNum == 1)
        {
            return Color.black
        }
        else if (colorNum == 2)
        {
            return Color.white
        }
        else if (colorNum == 3)
        {
            return Color.blue
        }
        else if (colorNum == 4)
        {
            return Color.red
        }
        else if (colorNum == 5)
        {
            return Color.yellow
        }
        else if (colorNum == 6)
        {
            return Color.orange
        }
        else
        {
            return Color.green
        }
    }
    
    func copyToClipboard()
    {
        pasteboard.string = statementObject.statement
        notification = textCopiedNotification
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5)
        {
            notification=""
        }
    }
    
    func deleteText()
    {
        if (statementObject.statement != "" && !history.statementHistory.contains(statementObject.statement))
        {
            history.statementHistory.append(statementObject.statement)
        }
        
        if(history.noPastStatements == true)
        {
            history.noPastStatements = false
        }
        
        statementObject.statement=""
    }
}

