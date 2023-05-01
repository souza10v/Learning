//
//  ContentView.swift
//  Learning
//
//  Created by Donizetti de Souza on 4/29/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView{
            
            VStack(alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading,20)
                
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            
                            // Learning Card
                            
                            HomeViewRow(image: module.content.image , title: "Learn \(module.category)", description: module.category, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                            
                            // Test Card
                            HomeViewRow(image: module.test.image , title: "Learn \(module.category) Test", description: module.category, count: "\(module.test.questions.count) Lessons", time: module.test.time)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Get Start")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}