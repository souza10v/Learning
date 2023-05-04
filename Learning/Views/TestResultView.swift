//
//  TestResultView.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/4/23.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var numCorrect: Int
    var resultHeading: String {
        
        guard model.currentModule != nil else { //se zero
            return ""
        }
        let pct = Double(numCorrect)/Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Awesome"
        }
        else if pct > 0.2 {
            return "Doing great!"
        }
        else {
            return "Keep Learning"
        }
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            Text(resultHeading)
                .font(.title)
            
            Spacer()
            
            Text("you got \(numCorrect) out \(model.currentModule?.test.questions.count ?? 0) questions")
            
            Spacer()
            
            Button {
                
                model.currentTestSelected = nil
                
                
            } label: {
                
                ZStack {
                    
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                    
                }
                
            }
            Spacer()
        }
        .padding()
    }
}
