//
//  DeafCommunicateModel.swift
//  Deaf Communicator
//
//  Created by Alex Demerjian on 6/25/23.
//

import Foundation

class DeafCommunicateModel: ObservableObject
{
    @Published var statement = ""
    @Published var statementHistory: [String] = []
    @Published var noPastStatements = true
}
