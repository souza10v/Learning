//
//  ContentView.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
                if model.currentModule != nil {

                    //ForEach(model.currentModule!.content.lessons) { lesson in // range in lessons
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in //range in array
                        
                        NavigationLink(
                            destination: ContentDetailView()
                            .onAppear(perform: {
                                model.beginLesson(index)
                            }),
                            label: {ContentViewRow(index: index)
                            })
                    }
                }
            }
            .accentColor(.black)
            .padding()
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "")")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentModel())
    }
}
