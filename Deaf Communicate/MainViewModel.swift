//
//  MainViewModel.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/25/23.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject{
    
    //Localized variables (multi language support)
    let textCopiedNotification: LocalizedStringKey = "Text Copied Notification"
    let instructionMessageOne:LocalizedStringKey = "Instruction Message One"
    
    @Published var statement = ""
    @Published var statementHistory: [String] = []
    @Published var noPastStatements = true
    @Published var fontSize: Double = 50.0
    @Published var fontStyle: String = "SF Pro Regular"
    @Published var isCustomFontColor: Bool = false
    @Published var fontColor: Color = Color.black
    @Published var showNotification = false
    @Published var notificationText: LocalizedStringKey? = nil
    @Published var notificationSymbol: String? = nil
    @Published var showHistorySheet: Bool = false
    
    func configureUserDefaults(){
        
        if let fontSize = UserDefaults.standard.object(forKey: "fontSize") as? Double{
            self.fontSize = fontSize
        }else{
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
        
        if let fontStyle = UserDefaults.standard.object(forKey: "fontStyle") as? String{
            self.fontStyle = fontStyle
        }else{
            //fontStyle = "SF Pro Regular"
            UserDefaults.standard.set(fontStyle, forKey: "fontStyle")
        }
         
        if let isCustomFontColor = UserDefaults.standard.object(forKey: "isCustomFontColor") as? Bool{
            self.isCustomFontColor = isCustomFontColor
        }else{
            //isCustomFontColor = false
            UserDefaults.standard.set(isCustomFontColor, forKey: "isCustomFontColor")
        }
        
        if let fontColorInt = UserDefaults.standard.object(forKey: "fontColorInt") as? Int{
            fontColor = fontColorInt.determineColor()
        }else{
            UserDefaults.standard.set(fontColor.determineInt(), forKey: "fontColorInt")
        }
    }
    
    func copyTextToClipboard(){
        
        UIPasteboard.general.string = statement
        
        DispatchQueue.main.async{
            self.notificationText = self.textCopiedNotification
            self.notificationSymbol = "doc.on.doc"
            
            withAnimation{
                self.showNotification.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5){
            
            withAnimation{
                self.showNotification.toggle()
            }
            
            self.notificationText = nil
            self.notificationSymbol = nil
        }
    }
    
    func deleteText(){
        
        if (statement != ""){
            statementHistory.append(statement)
            
            if noPastStatements {
                noPastStatements = false
            }
        }
        
        statement=""
    }
    
}
extension Color{
    
    func determineInt() -> Int{
        if (self == Color.black){
            return 1
        }else if (self == Color.white){
            return 2
        }else if (self == Color.blue){
            return 3
        }else if (self == Color.red){
            return 4
        }else if (self == Color.yellow){
            return 5
        }else if (self == Color.orange){
            return 6
        }else{
            return 7
        }
    }
    
}
extension Int{
    
    func determineColor() -> Color{
        if (self == 1){
            return Color.black
        }else if (self == 2){
            return Color.white
        }else if (self == 3){
            return Color.blue
        }else if (self == 4){
            return Color.red
        }else if (self == 5){
            return Color.yellow
        }else if (self == 6){
            return Color.orange
        }else{
            return Color.green
        }
    }
    
}
