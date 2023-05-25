//
//  TestView.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/2/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex: Int?
    @State var submitted = false
    @State var numCorrect = 0
    
    var body: some View {
        
        VStack {
            
            if model.currentQuestion != nil {
                
                VStack {
                    
                    // Question number
                    Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0 )")
                    
                    // Question
                    CodeTextView()
                        .padding(.horizontal, 20)
                    
                    // Answer
                    ScrollView {
                        VStack {
                            ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                                
                                Button {
                                    // Track selected index
                                    selectedAnswerIndex = index
                                    
                                } label: {
                                    
                                    ZStack {
                                        
                                        if submitted == false {
                                            RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            
                                        } else {
                                            // Answer has been submitted
                                            
                                            // index == selectedAnswerIndex para entender quando eh clicado
                                            if index == model.currentQuestion!.correctIndex && index == selectedAnswerIndex {
                                                
                                                // User has selected right answer
                                                // Show a green background
                                                RectangleCard(color: Color.green)
                                                    .frame(height: 48)
                                            }
                                            else if index == selectedAnswerIndex &&
                                                        index != model.currentQuestion!.correctIndex {
                                                
                                                // User has selected wrong answer
                                                // Show a red background
                                                RectangleCard(color: Color.red)
                                                    .frame(height: 48)
                                            }
                                            else if index == model.currentQuestion! . correctIndex {
                                                
                                                // This button is the corret answer
                                                // Show a green background
                                                RectangleCard(color: Color.green)
                                                    .frame(height: 48)
                                            }
                                            else {
                                                RectangleCard(color: Color.white)
                                                    .frame(height: 48)
                                            }
                                        }
                                        
                                        Text(model.currentQuestion!.answers[index])
        
                                    }
                                }
                                .disabled(submitted)
                            }
                        }
                        .accentColor(.black)
                        .padding()
                    }
                    
                    // Button
                    Button {
                        
                        // Check if answer has been submitted
                        if submitted == true {
                            model.nextQuestion()
                            
                            // Reset properties
                            submitted = false
                            selectedAnswerIndex = nil
                            
                        } else {
                            // Check the answer and incremente the counter if corret
                            submitted = true
                            
                            if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                                numCorrect += 1
                            }
                        }
                        
                    } label : {
                        
                        ZStack {
                            
                            RectangleCard(color: .green)
                                .frame(height: 48)
                            
                            Text(buttonText)
                                .foregroundColor(Color.white)
                                .bold()
                            
                        }
                        .padding()
                    }
                    .disabled(selectedAnswerIndex == nil)
                    
                }
                .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            }
            else {
                TestResultView(numCorrect: numCorrect)
            }
        }
        .padding()
    }
    
    var buttonText: String {
        
        // check if answer has been submited
        if submitted == true {
            if model.currentQuestionIndex + 1 ==  model.currentModule!.test.questions.count {
                return "Finish" // or finishe
            }
            else {
                return "Submit"
            }
        }
        else {
            return "Next"
        }
    }
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
