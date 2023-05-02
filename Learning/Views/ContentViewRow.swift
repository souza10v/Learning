//
//  ContentViewRow.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/1/23.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model : ContentModel
    var index: Int
    
    var body: some View {
        
        let lesson = model.currentModule!.content.lessons[index]

        // Lesson card
        ZStack(alignment: .leading){

            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack (spacing: 30) {
                
                Text(String(index + 1))
                    .bold()
                
                VStack(alignment: .leading) {
                    Text(lesson.title)
                    Text(lesson.duration)
                }
            }
            .padding()
        }
        .padding(.bottom, 10)
        
    }
}
