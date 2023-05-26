//
//  UserService.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/25/23.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
