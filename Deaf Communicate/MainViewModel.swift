//
//  MainViewModel.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/25/23.
//

import Foundation
import SwiftUI
import Speech

class MainViewModel: ObservableObject{
    
    //Localized variables (multi language support)
    let textCopiedNotification: LocalizedStringKey = "Text Copied Notification"
    let instructionMessageOne:LocalizedStringKey = "Instruction Message One"
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    @Published var isRecording = false
    @Published var text = ""
    @Published var textHistory: [TextHistoryContainer] = []
    @Published var noPastStatements = true
    @Published var fontSize: Double = 50.0
    @Published var fontStyle: String = "SF Pro Regular"
    @Published var isCustomFontColor: Bool = false
    @Published var fontColor: Color = Color.black
    @Published var showNotification = false
    @Published var notificationText: LocalizedStringKey? = nil
    @Published var notificationSymbol: String? = nil
    @Published var showTextHistory: Bool = false
    @Published var settingsIcon = Image("Settings-Not-Tapped")
    
    func requestPermission(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                break // Good to go
            default:
                print("Speech recognition authorization denied")
            }
        }
    }
    
    func startRecording() {
        
        // Ensure recognizer is available for the device's locale
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let speechRecognizer = speechRecognizer else {return}
        guard speechRecognizer.isAvailable == true else {return}
        
        // Setup recognition request
        recognitionRequest.shouldReportPartialResults = true
        speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                // Update the UI with the results
                self.text = result.bestTranscription.formattedString
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // Prepare and start recording
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio engine failed to start")
        }
    }
    
    func stopRecording(){
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isRecording = false
    }
    
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
        
        UIPasteboard.general.string = text
        
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
        text=""
    }
    
    func saveTextToHistory(){
        
        if (text != ""){
            textHistory.append(TextHistoryContainer(text: text))
            
            if noPastStatements {
                noPastStatements = false
            }
        }
        
        text=""
        
    }
    
    
    func deleteTextFromHistory(at offsets: IndexSet){
        textHistory.remove(atOffsets: offsets)
        
        if textHistory.count == 0{
            Task(priority: .userInitiated){
                await MainActor.run{
                    showTextHistory = false
                }
            }
        }
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
