//
//  TextEditorViewModel.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/25/23.
//

import Foundation
import SwiftUI


class TextBoardViewModel: ObservableObject
{
    //Localized variables (for multi language support)
    let instructionMessageOne:LocalizedStringKey = "Instruction Message One"
    let navigationTitleOne:LocalizedStringKey = "Navigation Title One"
    let textCopiedNotification: LocalizedStringKey = "Text Copied Notification"
    
    @Published var notification: LocalizedStringKey! = nil
    
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
    
    func copyToClipboard(deafCommunicateModel: DeafCommunicateModel)
    {
        UIPasteboard.general.string = deafCommunicateModel.statement
        notification = textCopiedNotification
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5)
        {
            self.notification=""
        }
    }
    
    func deleteText(deafCommunicateModel: DeafCommunicateModel)
    {
        if (deafCommunicateModel.statement != "" && !deafCommunicateModel.statementHistory.contains(deafCommunicateModel.statement))
        {
            deafCommunicateModel.statementHistory.append(deafCommunicateModel.statement)
        }
        
        if(deafCommunicateModel.noPastStatements == true)
        {
            deafCommunicateModel.noPastStatements = false
        }
        
        deafCommunicateModel.statement=""
    }
}
