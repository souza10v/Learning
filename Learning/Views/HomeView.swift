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
                            
                            VStack (spacing: 20) {
                                                 
                                NavigationLink(destination: ContentView()
                                    .onAppear(perform: {
                                        model.getLessons(module: module, completion: {model.beginModule(module.id)})
                                        
                                    }),
                                               tag: module.id.hash,
                                               selection: $model.currentContentSelected,
                                            label: {
                                    
                                    // Learning Card
                                    HomeViewRow(image: module.content.image , title: "Learn \(module.category)", description: module.category, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                })
                                
                                NavigationLink(destination: TestView()
                                    .onAppear(perform: {
                                        model.getQuestion(module: module) {
                                            model.beginTest(module.id)
                                        }
                                    }),
                                               tag: module.id.hash,
                                               selection: $model.currentTestSelected,
                                               label: {
                                    // Test Card
                                    HomeViewRow(image: module.test.image , title: "Learn \(module.category) Test", description: module.category, count: "\(module.test.questions.count) Lessons", time: module.test.time)
                                })
                                
                                NavigationLink(destination: EmptyView()) {
                                    EmptyView()
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle("Get Started")
            .onChange(of: model.currentContentSelected) { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            }
            .onChange(of: model.currentTestSelected) { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
