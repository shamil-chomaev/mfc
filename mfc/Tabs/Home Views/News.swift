//
//  News.swift
//  mfc
//
//  Created by Shamil Chomaev on 25.10.2020.
//

import SwiftUI
import FirebaseFirestore

struct News: View {
    
    @State var isAuth: Bool = false
    @State var news: [NewsStruct] = [NewsStruct(id: "", title: "Тестовая новость", description: "To fetch data from Firestore, you’ll first have to connect your app to Firebase. I’m not going to go into great detail about this here - if you’re new to Firebase (or your background is in Android or web development), check out this video which will walk you through the process (don’t worry, it’s not very complicated).", imageUrl: "s", create: Date(), createUser: "sham.chom77@gmail.com", visible: false)]
    


    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: true){
                
                VStack(alignment: .center, spacing: 15) {
                    ForEach(self.news.sorted(by: { $0.create > $1.create })) { item in
                        NewsElement(item: item)
                            .frame(width: UIScreen.main.bounds.width-24, height: UIScreen.main.bounds.width-24)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                
            }
            .onAppear(){
                self.isAuth = UserProfileControl.UserStatus()
                self.fetchData()
            }
            .navigationTitle("Новости")
            .navigationBarItems(trailing: Group {
                if isAuth {
                    NavigationLink(destination: AddNews()) {
                        Image(systemName: "plus")
                    }
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func fetchData() {
        print("fetchData")
        Firestore.firestore().collection("news").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.news = documents.compactMap { queryDocumentSnapshot -> NewsStruct? in
                print(self.news.count)
                return try? queryDocumentSnapshot.data(as: NewsStruct.self)
            }
        }
    }
}

struct News_Previews: PreviewProvider {
    static var previews: some View {
        News()
    }
}



struct TouchGestureViewModifier: ViewModifier {

    let minimumDistance: CGFloat
    let touchBegan: () -> Void
    let touchEnd: (Bool) -> Void

    @State private var hasBegun = false
    @State private var hasEnded = false

    init(minimumDistance: CGFloat, touchBegan: @escaping () -> Void, touchEnd: @escaping (Bool) -> Void) {
        self.minimumDistance = minimumDistance
        self.touchBegan = touchBegan
        self.touchEnd = touchEnd
    }

    private func isTooFar(_ translation: CGSize) -> Bool {
        let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
        return distance >= minimumDistance
    }

    func body(content: Content) -> some View {
        content.gesture(DragGesture(minimumDistance: 0)
            .onChanged { event in
                guard !self.hasEnded else { return }

                if self.hasBegun == false {
                    self.hasBegun = true
                    self.touchBegan()
                } else if self.isTooFar(event.translation) {
                    self.hasEnded = true
                    self.touchEnd(false)
                }
            }
            .onEnded { event in
                if !self.hasEnded {
                    let success = !self.isTooFar(event.translation)
                    self.touchEnd(success)
                }
                self.hasBegun = false
                self.hasEnded = false
            }
        )
    }
}

extension View {
    func onTouchGesture(minimumDistance: CGFloat = 20.0,
                        touchBegan: @escaping () -> Void,
                        touchEnd: @escaping (Bool) -> Void) -> some View {
        modifier(TouchGestureViewModifier(minimumDistance: minimumDistance, touchBegan: touchBegan, touchEnd: touchEnd))
    }
}
