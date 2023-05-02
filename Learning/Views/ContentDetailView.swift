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
            
            // Show next lesson button, only if there is a next lesson
            
            if model.hasNextLesson() {
                
                Button {
                    
                    model.nextLesson()
                    
                } label: {
                    
                    ZStack {
                        
                        Rectangle()
                            .frame(height: 48)
                            .foregroundColor(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Text("Next Lesson \(model.currentModule!.content.lessons[model.currentLessonIndex].title)")
                            .foregroundColor(Color.white)
                            .bold()
                        
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
