//
//  Profile.swift
//  mfc
//
//  Created by Shamil Chomaev on 24.10.2020.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Profile: View {
    
    @State var showAuthView: Bool = false
    @State var authState: AuthViewState = .authorization
    
    @State var isAuth: Bool = false
    
    @State var uemail: String = ""
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: true){
                VStack(alignment: .center, spacing: 20) {
                    
                    if isAuth {
                        
                        ProfileView(uemail: uemail)
                    } else {
                        ZStack(alignment: .center) {
                            
                            Color("BackgroundColorRow")
                            
                            Button(action: {
                                self.authState = .authorization
                                self.showAuthView = true
                                print("authorization")
                            }){
                                HStack(alignment: .center, spacing: 10.0){
                                    Image(systemName: "arkit")
                                        .font(.body)
                                        
                                        .frame(width: 20)
                                    //                Divider()
                                    Text("Вход")
                                        .font(.body)
                                        .fontWeight(.regular)
                                    
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.body)
                                        .foregroundColor(Color("Primary"))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(15)
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal ,15)
                        
                    }
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        SectionTitle(title: "Сервис")
                        URLButtonView(image: "arkit", title: "Участвовать в разработке", url: "https://t.me/joinchat/AAAAAFWCjDfLSi-i_g_6fQ")
                        
                        
                        URLButtonView(image: "text.bubble", title: "Написать разработчику", url: "https://instagram.com/dv.shama")
                        
                        URLButtonView(image: "circle.grid.hex", title: "Открытый бэклог", url: "https://instagram.com/dv.shama")
                    }
                    .padding(.horizontal ,15)
                    
                    if isAuth {
                        Divider()
                        ProfileServiceView(isAuth: $isAuth)
                    }
                    Divider()
                    AppInfoView()
                }
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width)
                //                .padding(.horizontal)
            }
            .sheet(isPresented: $showAuthView) {
                AuthView(showAuthView: $showAuthView, isAuth: $isAuth, stateAuth: authState)
            }
            .onAppear(){
                if Auth.auth().currentUser != nil {
                    self.uemail = (Auth.auth().currentUser?.email)!
                    self.isAuth = true
                
                } else {
                    self.isAuth = false
                  // No user is signed in.
                  // ...
                }
            }
            .navigationTitle("Профиль")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProfileView: View {
    
    @State var fullName: String = ""
    @State var email: String = ""
    
    var uemail: String
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 15){
                //                Image("shamiltestphoto")//"unfoundpic")
                Image("unfoundpic")//"unfoundpic")
                    .resizable()
                    .frame(width: 125, height: 125)
                    .aspectRatio(1, contentMode: .fit)
                    //                    .mask(Circle())
                    .clipShape(Circle())
                    //                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color("Primary"), lineWidth: 3))
                
                Text(fullName)
                    .font(.title)
                    .fontWeight(.bold)
                
                
                ZStack(alignment: .leading) {
                    Color("BackgroundColorRow")
                    VStack(alignment: .leading, spacing: 0){
                        Text("Электронная почта")
                            .font(.caption)
                            .fontWeight(.light)
                        Text(email)
                            .font(.body)
                            .fontWeight(.bold)
                    }
                    .padding(15)
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
//                ZStack(alignment: .leading) {
//                    Color("BackgroundColorRow")
//                    VStack(alignment: .leading, spacing: 0){
//                        Text("Телефон")
//                            .font(.caption)
//                            .fontWeight(.light)
//                        Text("+7-999-999-99-99")
//                            .font(.body)
//                            .fontWeight(.bold)
//                    }
//                    .padding(15)
//                }
//                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(15)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
        .onAppear(){
            Firestore.firestore().collection("users").document(uemail).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    
                    self.fullName = "\(document.get("lastName") as! String) \(document.get("firstName") as! String)"
                    self.email = document.get("email") as! String
                    
                    UserProfileControl.SetUserStatus(tp: "\(document.get("type") as! String)")
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

struct ProfileServiceView: View {
    
    @Binding var isAuth: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            
            //            Color.gray.opacity(0.1)//(."BackgroundColorRow")
            
            VStack(alignment: .center, spacing: 10.0){
                Button(action: {
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        UserProfileControl.DeleteUserStatus()
                        self.isAuth = false
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    
                    //                    let url = URL (string: "https://instagram.com/dv.shama")!
                    //                    UIApplication.shared.open (url)
                }){
                    Text("Выйти")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(15)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


struct SectionTitle: View {
    var title: String
    
    var body: some View {
        HStack(alignment: .center){
            Text(title)
                .font(.caption)
            Spacer()
        }
    }
}
struct URLButtonView: View {
    
    var image: String
    var title: String
    var url: String
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color("BackgroundColorRow")
            
            Button(action: {
                
                let openUrl = URL (string: "\(url)")!
                UIApplication.shared.open (openUrl)
            }){
                HStack(alignment: .center, spacing: 10.0){
                    Image(systemName: image)
                        .font(.body)
                        
                        .frame(width: 20)
                    //                Divider()
                    Text(title)
                        .font(.body)
                        .fontWeight(.regular)
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.body)
                        .foregroundColor(Color("Primary"))
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(15)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}



struct AppInfoView: View {
    
    @State var version: String = "0.0.0"
    @State var build: String = "0"
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Button(action: {
                let url = URL (string: "https://instagram.com/dv.shama")!
                UIApplication.shared.open (url)
            }){
                Text("Политика конфиденциальности")
                    .font(.caption)
                    .fontWeight(.light)
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                let url = URL (string: "https://instagram.com/dv.shama")!
                UIApplication.shared.open (url)
            }){
                Text("О приложении")
                    .font(.caption)
                    .fontWeight(.light)
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
            Text("Версия \(version) (\(build))")
                .font(.caption)
                .fontWeight(.light)
        }
        .onAppear(){
            if let versionBundle = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               let buildBundle = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                
                self.build = buildBundle
                self.version = versionBundle
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
