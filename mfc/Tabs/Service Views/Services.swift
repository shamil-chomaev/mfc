//
//  Services.swift
//  mfc
//
//  Created by Shamil Chomaev on 28.10.2020.
//

import SwiftUI

struct Services: View {
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: true){
                
                VStack {
                    Text("Тут будет текст")
                }
            }           .navigationTitle("Услуги")
        }
    }
}

struct Services_Previews: PreviewProvider {
    static var previews: some View {
        Services()
    }
}
