//
//  ResumeView.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/27/23.
//

import SwiftUI

struct ResumeView: View {
    
    @EnvironmentObject var model:ContentModel
    let user = UserService.shared.user
    
    var resumeTitle: String {
        
        let module = model.modules[user.lastModule ?? 0]
        
        if user.lastLesson != 0 {
            // Resume a lesson
            return "Learn \(module.category): Lesson \(user.lastLesson! + 1)"
        }
        else {
            // Resume a test
            return "\(module.category) Test: Question \(user.lastQuestion! + 1)"
        }
    }
    
    var body: some View {
        
        ZStack{
    
            RectangleCard(color: .white)
                .frame(height: 66)
            
            HStack{
                VStack(alignment: .leading){
                    Text("Continue where you let off:")
                    Text(resumeTitle)
                        .bold()
                }
                Spacer()
                Image("play")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .padding()
        }
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
    }
}
