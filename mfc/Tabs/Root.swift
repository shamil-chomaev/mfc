//
//  Root.swift
//  mfc
//
//  Created by Shamil Chomaev on 23.09.2020.
//

import SwiftUI

//init() {
//    UITabBar.appearance().backgroundColor = UIColor.clear
//    UITabBar.appearance().unselectedItemTintColor = UIColor.init(named: "unselect")
////        UINavigationBar.appearance().backgroundColor = .black
//}

struct Root: View {
    
    @State var selectedView = 1
    
    var body: some View {
        TabView(selection: $selectedView) {
            News()
            .tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("Новости")
                    .fontWeight(.bold)
                
            }.tag(1)
            Maps()
            .tabItem {
                Image(systemName: "mappin.and.ellipse")
                //                            .animation(.spring())
                Text("На карте")
                    .fontWeight(.bold)
                
            }.tag(2)
            Services()
            .tabItem {
                Image(systemName: "briefcase")
                //                            .animation(.spring())
                Text("Услуги")
                    .fontWeight(.bold)
                
            }.tag(3)
            NavigationView{
                ScrollView(.vertical, showsIndicators: true){
                    
                    VStack {
                        Text("Тут будет текст")
                    }
                }            .navigationTitle("Справки")
            }
            .tabItem {
                Image(systemName: "book")
                //                            .animation(.spring())
                Text("Справки")
                    .fontWeight(.bold)
                
            }.tag(4)
            Profile()
            .tabItem {
                Image(systemName: "person")
                Text("Профиль")
                    .fontWeight(.bold)
                
            }.tag(5)
        }
    }
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root()
    }
}
