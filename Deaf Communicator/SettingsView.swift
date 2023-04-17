//
//  SettingsView.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 6/26/22.
//

import SwiftUI

struct SettingsView: View
{
    
    //General variables
    let colors = [Color.black, Color.white, Color.blue, Color.red, Color.yellow, Color.orange, Color.green]
    let fontStyles = ["SF Pro Regular", "Times New Roman",
    "Times New Roman Bold", "Arial", "Arial Bold", "Bradley Hand Bold", "Copperplate Bold", "Chalkboard SE Regular", "Chalkboard SE Bold", "Chalkduster", "Courier", "Courier Bold", "Noteworthy Light", "Noteworthy Bold", "Optima Regular", "Optima Bold", "Papyrus", "Party LET Plain", "Rockwell", "Rockwell Bold", "Savoye LET Plain", "Symbol", "Verdana", "Verdana Bold"]
    @State var fontSize = 50.0
    @State var fontStyle = "SF Pro Regular"
    @State var customFontColor = Color.black
    @State var customColor = false
    
    //Localized variables (for multi language support)
    let navigationTitleTwo : LocalizedStringKey = "Navigation Title Two"
    let settingsFontTextOne : LocalizedStringKey = "Settings Font Text One"
    let settingsFontTextTwo : LocalizedStringKey = "Settings Font Text Two"
    let settingsFontTextThree: LocalizedStringKey = "Settings Font Text Three"
    let settingsFontStyleOne : LocalizedStringKey = "Settings Font Style One"
    let settingsFontStyleTwo : LocalizedStringKey = "Settings Font Style Two"
    let settingsFontStyleThree : LocalizedStringKey = "Settings Font Style Three"
    let settingsFontColorOne : LocalizedStringKey = "Settings Font Color One"
    let settingsFontColorTwo : LocalizedStringKey = "Settings Font Color Two"
    let settingsFontColorThree : LocalizedStringKey = "Settings Font Color Three"
    
    init()
    {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                if #available(iOS 16, *)
                {
                    Text(settingsFontStyleThree)
                        .frame(height:100)
                        .font(Font.custom(fontStyle, size: fontSize))
                        .foregroundColor(customFontColor)
                        .background(.gray.opacity(0.3))
                        .cornerRadius(8)
                        .padding()
                }
                else
                {
                    Text(settingsFontStyleThree)
                        .frame(height:100)
                        .font(Font.custom(fontStyle, size: fontSize))
                        .foregroundColor(customFontColor)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        .padding()
                }
                
                
                        
                Button(action:{
                    fontSize = 50.0
                    fontStyle = "SF Pro Regular"
                    customFontColor = Color.black
                    customColor = false})
                {
                    Image(systemName: "arrow.counterclockwise")
                    Text(settingsFontTextThree)
                }
                .buttonStyle(.bordered)
                
            
                
                Text(settingsFontTextOne)
                    .font(.system(size:30, weight: .heavy))
                    .padding()
                
                HStack
                {
                    Text(settingsFontTextTwo)
                        .font(.system(size:20))
                    Text("\(fontSize, specifier: "%.1f"))")
                        .font(.system(size:20))
                }
                
                HStack
                {
                    Image(systemName: "minus")
                    Slider(value:$fontSize, in:25...150)
                        .padding()
                        .accentColor(Color.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15.0)
                                .stroke(lineWidth: 2.0)
                                .foregroundColor(Color.gray)
                        )
                    Image(systemName: "plus")
                }
                .padding()
                
                
                Rectangle()
                    .fill(.gray)
                    .frame(height:2)
                
                Text(settingsFontStyleOne)
                    .font(.system(size:30, weight: .heavy))
                    .padding()
                
                
                Picker(settingsFontStyleTwo, selection:$fontStyle)
                {
                    ForEach(fontStyles, id:\.self)
                    {
                        Label($0.self, systemImage: "pencil")
                    }
                }
                .pickerStyle(.wheel)
                
                
                Rectangle()
                    .fill(.gray)
                    .frame(height:2)
                
                VStack
                {
                    
                    Text(settingsFontColorOne)
                        .font(.system(size:30, weight: .heavy))
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding()
                    
                    Toggle(settingsFontColorTwo, isOn: $customColor)
                        .padding()
                    
                }
                .navigationTitle(navigationTitleTwo)
            }
            
            if customColor
            {
                Picker(settingsFontColorThree, selection: $customFontColor)
                {
                    ForEach(colors, id:\.self)
                    {
                        Label($0.description, systemImage: "paintbrush")
                    }
                    
                }
                .pickerStyle(.wheel)
            }
            
        }
        .onAppear(perform: {
            
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
        .onDisappear(perform: {
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
            UserDefaults.standard.set(fontStyle, forKey: "fontStyle")
            UserDefaults.standard.set(determineNum(color: customFontColor), forKey: "customFontColor")
            UserDefaults.standard.set(customColor, forKey: "customColor")
        })
        
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
    
    func determineNum(color: Color) -> Int
    {
        if (color == Color.black)
        {
            return 1
        }
        else if (color == Color.white)
        {
            return 2
        }
        else if (color == Color.blue)
        {
            return 3
        }
        else if (color == Color.red)
        {
            return 4
        }
        else if (color == Color.yellow)
        {
            return 5
        }
        else if (color == Color.orange)
        {
            return 6
        }
        else
        {
            return 7
        }
    }
    
}


