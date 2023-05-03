//
//  TestView.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/2/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        VStack {
            
            if model.currentQuestion != nil {
                
                VStack {
                    
                    // Question number
                    Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0 )")
                    
                    // Question
                    CodeTextView()
                    
                    // Answer
                    
                    // Button
                }
                .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            }
        }
        .padding()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
