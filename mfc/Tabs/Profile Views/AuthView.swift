//
//  AuthView.swift
//  mfc
//
//  Created by Shamil Chomaev on 24.10.2020.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AuthView: View {
    
    @Binding var showAuthView: Bool
    @Binding var isAuth: Bool
    
    @State var stateAuth: AuthViewState = .registration
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var loading: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                
                Picker(selection: $stateAuth, label: Text("Picker")){
                    Text("Авторизация").tag(AuthViewState.authorization)
                    Text("Регистрация").tag(AuthViewState.registration)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)
                
                if stateAuth == .authorization {
                    AuthorizationProfileView(stateAuth: $stateAuth,
                                             email: $email,
                                             password: $password,
                                             showAuthView: $showAuthView, loading: $loading,
                                             isAuth: $isAuth)
                        .padding(.top)
                }
                else if stateAuth == .passwordRecovery {
                    PasswordRecoveryProfileView(stateAuth: $stateAuth,
                                                email: $email,
                                                loading: $loading)
                        .padding(.top)
                } else
                if stateAuth == .registration {
                    RegistrationProfileView(stateAuth: $stateAuth,
                                            email: $email,
                                            loading: $showAuthView, isAuth: $loading,
                                            showAuthView: $isAuth)
                        .padding(.top)
                }
            }
            .padding(.horizontal)
            .navigationBarTitle(stateAuth == .registration ? "Регистрация" : "Вход", displayMode: .inline)
        }
    }
}
//
//struct AuthView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthView(showAuthView: .constant(true))
//    }
//}


enum AuthViewState {
    case authorization
    case registration
    case passwordRecovery
}

struct AuthorizationProfileView: View {
    
    @Binding var stateAuth: AuthViewState
    
    @Binding var email: String
    @Binding var password: String
    @Binding var showAuthView: Bool
    
    @Binding var loading: Bool
    @Binding var isAuth: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Color("BackgroundColorRow")
                VStack(alignment: .leading, spacing: 10){
                    Text("Электронная почта")
                        .font(.caption)
                        .fontWeight(.light)
                    TextField("@", text: $email)
                        .font(.body)
                        .keyboardType(.emailAddress)
                }
                .padding(15)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            ZStack(alignment: .leading) {
                Color("BackgroundColorRow")
                VStack(alignment: .leading, spacing: 10){
                    Text("Пароль")
                        .font(.caption)
                        .fontWeight(.light)
                    HStack{
                        SecureField("Your password", text: $password)
                            .font(.body)
                        Spacer()
                        Button(action: {
                            
                            withAnimation(.default){
                                self.stateAuth = .passwordRecovery
                            }
                        }){
                            Image(systemName: "questionmark.circle.fill")
                                .font(.body)
                                .foregroundColor(Color("Primary"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(15)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            ZStack(alignment: .leading) {
                
                Color("BackgroundColorRow")
                
                Button(action: {
                    self.authorizationFirebase(email: email, password: password)
                }){
                    HStack(alignment: .center, spacing: 10.0){
                        Text("Войти")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        Image(systemName: "bolt.fill")
                            .font(.body)
                            .foregroundColor(Color.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(15)
                .background(Color("Primary"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top)
        }
    }
    
    func authorizationFirebase(email: String, password: String) {
        self.loading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error)
            } else {
                let uemail = authResult?.user.email
                
                Firestore.firestore().collection("users").document(uemail ?? email).updateData([
                    "lastSign": Date()
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.loading = false
                        self.showAuthView = false
                        self.isAuth = true
                    }
                }
            }
        }
        
        
        self.loading = false
    }
}

struct PasswordRecoveryProfileView: View {
    
    @Binding var stateAuth: AuthViewState
    
    @Binding var email: String
    
    @Binding var loading: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Color("BackgroundColorRow")
                VStack(alignment: .leading, spacing: 10){
                    Text("Электронная почта")
                        .font(.caption)
                        .fontWeight(.light)
                    TextField("@", text: $email)
                        .font(.body)
                        .keyboardType(.emailAddress)
                }
                .padding(15)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Button(action: {
                withAnimation(.default){
                    self.stateAuth = .authorization
                }
            }) {
                Text("Вернуться ко входу")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(Color("Primary"))
            }
            .buttonStyle(PlainButtonStyle())
            
            ZStack(alignment: .leading) {
                
                Color("BackgroundColorRow")
                
                Button(action: {
                    self.passwordRecoveryFirebase(email: email)
                }){
                    HStack(alignment: .center, spacing: 10.0){
                        Text("Восстановить пароль")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        Image(systemName: "bolt.fill")
                            .font(.body)
                            .foregroundColor(Color.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(15)
                .background(Color("Primary"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top)
        }
    }
    
    func passwordRecoveryFirebase(email: String) {
        self.loading = true
        
        print("\(email))")
        
        self.loading = false
    }
}


struct RegistrationProfileView: View {
    
    @Binding var stateAuth: AuthViewState
    
    @Binding var email: String
    
    @Binding var loading: Bool
    @Binding var isAuth: Bool
    @Binding var showAuthView: Bool
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var rePassword: String = ""
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .leading) {
                Color("BackgroundColorRow")
                VStack(alignment: .leading, spacing: 10){
                    Text("Имя")
                        .font(.caption)
                        .fontWeight(.light)
                    TextField("Иван", text: $firstName)
                        .font(.body)
                        .keyboardType(.emailAddress)
                }
                .padding(15)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            ZStack(alignment: .leading) {
                Color("BackgroundColorRow")
                VStack(alignment: .leading, spacing: 10){
                    Text("Фамилия")
                        .font(.caption)
                        .fontWeight(.light)
                    TextField("Иванов", text: $lastName)
                        .font(.body)
                        .keyboardType(.emailAddress)
                }
                .padding(15)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Divider()
            
            ZStack(alignment: .leading) {
                Color("BackgroundColorRow")
                VStack(alignment: .leading, spacing: 10){
                    Text("Электронная почта")
                        .font(.caption)
                        .fontWeight(.light)
                    TextField("@", text: $email)
                        .font(.body)
                        .keyboardType(.emailAddress)
                }
                .padding(15)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            ZStack(alignment: .leading) {
                Color("BackgroundColorRow")
                VStack(alignment: .leading, spacing: 10){
                    Text("Пароль")
                        .font(.caption)
                        .fontWeight(.light)
                    SecureField("Your password", text: $password)
                        .font(.body)
                }
                .padding(15)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            ZStack(alignment: .leading) {
                
                Color("BackgroundColorRow")
                
                Button(action: {
                    self.registrationFirebase(firstName: firstName, lastName: lastName, email: email, password: password)
                }){
                    HStack(alignment: .center, spacing: 10.0){
                        Text("Регистрация")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        Image(systemName: "bolt.fill")
                            .font(.body)
                            .foregroundColor(Color.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(15)
                .background(Color("Primary"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top)
        }
    }
    
    func registrationFirebase(firstName: String, lastName: String, email: String, password: String) {
        self.loading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error)
            } else {
                let uid = authResult?.user.uid
                let uemail = authResult?.user.email
                
                Firestore.firestore().collection("users").document(uemail ?? email).setData([
                    "uid": uid ?? "",
                    "email": uemail,
                    "firstName": firstName,
                    "lastName": lastName,
                    "type": "user",
                    "create": Date(),
                    "lastSign": Date()
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.loading = false
                    }
                }
            }
        }
        
    }
}

struct AuthProfileView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var authState: AuthViewState = .authorization
    
    var body: some View {
        ZStack(alignment: .center) {
            
            //            Color.gray.opacity(0.1)//(."BackgroundColorRow")
            
            VStack(alignment: .center, spacing: 15){
                
                Text("Для полноценной работы приложения требуется авторизация")
                    .font(.body)
                    .fontWeight(.bold)
                    .lineLimit(4)
                
                // Имя + Фамилия
                if authState == .registration {
                    ZStack(alignment: .leading) {
                        Color("BackgroundColorRow")
                        VStack(alignment: .leading, spacing: 0){
                            Text("Имя")
                                .font(.caption)
                                .fontWeight(.light)
                            TextField("Иван", text: $firstName)
                                .font(.body)
                        }
                        .padding(15)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    ZStack(alignment: .leading) {
                        Color("BackgroundColorRow")
                        VStack(alignment: .leading, spacing: 0){
                            Text("Фамилия")
                                .font(.caption)
                                .fontWeight(.light)
                            TextField("Иванов", text: $lastName)
                                .font(.body)
                        }
                        .padding(15)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                }
                
                
                // Пароль авторизации
                if authState == AuthViewState.authorization {
                    ZStack(alignment: .leading) {
                        Color("BackgroundColorRow")
                        VStack(alignment: .leading, spacing: 0){
                            Text("Пароль")
                                .font(.caption)
                                .fontWeight(.light)
                            HStack{
                                SecureField("Your password", text: $password)
                                    .font(.body)
                                Spacer()
                                Button(action: {
                                    self.authState = .passwordRecovery
                                }){
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.body)
                                        .foregroundColor(Color("Primary"))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(15)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                if authState == AuthViewState.authorization {
                    ZStack(alignment: .leading) {
                        Color("BackgroundColorRow")
                        VStack(alignment: .leading, spacing: 0){
                            Text("Пароль")
                                .font(.caption)
                                .fontWeight(.light)
                            HStack{
                                SecureField("Your password", text: $password)
                                    .font(.body)
                                Spacer()
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.body)
                                    .foregroundColor(Color("Primary"))
                            }
                        }
                        .padding(15)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                if authState == AuthViewState.authorization {
                    ZStack(alignment: .leading) {
                        Color("BackgroundColorRow")
                        VStack(alignment: .leading, spacing: 0){
                            Text("Пароль")
                                .font(.caption)
                                .fontWeight(.light)
                            HStack{
                                SecureField("Your password", text: $password)
                                    .font(.body)
                                Spacer()
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.body)
                                    .foregroundColor(Color("Primary"))
                            }
                        }
                        .padding(15)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                ZStack(alignment: .leading) {
                    
                    Color("BackgroundColorRow")
                    
                    Button(action: {
                    }){
                        HStack(alignment: .center, spacing: 10.0){
                            Text(self.getTitleButton(auth: authState))
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            Image(systemName: "bolt.fill")
                                .font(.body)
                                .foregroundColor(Color.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(15)
                    .background(Color("Primary"))
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(15)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    func getTitleButton(auth: AuthViewState) -> String {
        switch auth {
        case .authorization:
            return "Авторизация"
        case .registration:
            return "Регистрация"
        case .passwordRecovery:
            return "Восстановление пароля"
        }
    }
}



