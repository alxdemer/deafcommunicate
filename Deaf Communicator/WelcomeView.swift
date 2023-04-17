//
//  WelcomeView.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 7/10/22.
//

import SwiftUI

struct WelcomeView: View {
    
    //localized variables
    let welcomeMessageTextOne : LocalizedStringKey = "Welcome Message Text One"
    let welcomeMessageTextTwo: LocalizedStringKey = "Welcome Message Text Two"
    
    //general variables
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        
        Text(welcomeMessageTextOne)
            .font(.system(size:40, weight: .heavy))
        
        Image("Deaf Communicate Logo")
            .resizable()
            .frame(width: 200.0, height: 200.0)
            .cornerRadius(10)
            .padding()
        
        Text("V." + appVersion!)
        
        Rectangle()
            .fill(.blue)
            .frame(height:3)
        
        Text(welcomeMessageTextTwo)
            .font(.system(size:20, weight: .heavy))
            .padding()
        
        Rectangle()
            .fill(.blue)
            .frame(height:3)
        
        Image("DemeraX Logo")
            .resizable()
            .frame(width: 300.0, height: 100.0)
            .padding()
        
        Text("© 2022 DemeraX Software")
            .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
