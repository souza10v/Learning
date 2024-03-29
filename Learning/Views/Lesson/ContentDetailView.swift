//
//  ContentDetailView.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/1/23.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            
            // Only show video if get a valid URL
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // TODO: Descripiton
            
            CodeTextView()
            
            // Show next lesson button, only if there is a next lesson
            
            if model.hasNextLesson() {
                
                Button {
                    
                    model.nextLesson()
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Next Lesson \(model.currentModule!.content.lessons[model.currentLessonIndex].title)")
                            .foregroundColor(Color.white)
                            .bold()
                        
                    }
                }
            }
            else {
                
                // Show complete button instead
                
                Button {
                    
                    // Call next lesson
                    model.nextLesson()
                    
                    // Take the user back to the homeview
                    model.currentContentSelected = nil
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .bold()
                        
                    }
                }
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
