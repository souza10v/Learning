//
//  ResumeView.swift
//  Learning
//
//  Created by Donizetti de Souza on 5/27/23.
//

import SwiftUI

struct ResumeView: View {
    var body: some View {
        
        ZStack{
    
            RectangleCard(color: .white)
                .frame(height: 66)
            
            HStack{
                VStack(alignment: .leading){
                    Text("Continue where you let off:")
                    Text("Learn Swift: What are the clousures")
                }
                Spacer()
                Image("play")
                    .frame(width:40, height: 40)
            }
        }
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
    }
}
