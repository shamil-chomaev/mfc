//
//  ContentView.swift
//  mfc
//
//  Created by Shamil Chomaev on 23.09.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NewsElement(item: NewsStruct(title: "Тестовая новость",
                                   description: "To fetch data from Firestore, you’ll first have to connect your app to Firebase. I’m not going to go into great detail about this here - if you’re new to Firebase (or your background is in Android or web development), check out this video which will walk you through the process (don’t worry, it’s not very complicated).",
                                   imageUrl: "https://wylsa.com/wp-content/uploads/2020/10/iphone-12-pro-1.jpg",
                                   create: Date(),
                                   createUser: "sham.chom77@gmail.com",
                                   visible: true))
            .padding()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
