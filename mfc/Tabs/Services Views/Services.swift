//
//  Services.swift
//  mfc
//
//  Created by Shamil Chomaev on 06.12.2020.
//

import SwiftUI
import Firebase

struct Services: View {
    
    @State var isAuth: Bool = false
    @State var arrayServices: [ServicesStruct] = [ServicesStruct(id: "UID", title: "NT", type: "ALL", description: "DT", order: 0)]
    //        ServicesStructtt(title: "Выдача паспорта",
    //                                                          type: .fed,
    //                                                          description: "Выдача или замена паспорта",
    //                                                          order: 1),
    //                                                    ServicesStructtt(title: "Выдача загран паспорта",
    //                                                          type: .fed,
    //                                                          description: "Государственный кадастровый учет недвижимого имущества и (или) государственная регистрация прав на недвижимое имущество и сделок с ним.",
    //                                                          order: 2),
    //                                                    ServicesStructtt(title: "Предоставление сведений, содержащихся в Едином государственном реестре недвижимости",
    //                                                          type: .mun,
    //                                                          description: "",
    //                                                          order: 1)]
    
    
    @State var selectType: ServicesEnum = .all
    
    @State var searchText: String = ""
    @State var isSearching: Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: true){
                HStack {
                    HStack {
                        TextField("Поиск услуг", text: $searchText)
                            .padding(.leading, 24)
                    }
                    .padding()
                    .background(Color("BackgroundColorRow"))
                    .cornerRadius(6)
                    .padding(.horizontal)
                    .onTapGesture {
                        isSearching = true
                    }
                    .overlay(
                        HStack{
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            
                            if isSearching {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .padding(.vertical)
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                        .foregroundColor(.gray)
                    )
                    .transition(.move(edge: .trailing))
                    .animation(.spring())
                    
                    if isSearching {
                        Button(action: {
                            isSearching = false
                            searchText = ""
                        }, label: {
                            Text("Отмена")
                                .padding(.trailing)
                                .padding(.leading, 0)
                            
                        })
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                    }
                }
                
                .padding(.bottom)
                
                
                VStack(alignment: .leading, spacing: 20) {
                
                    if !isSearching {
                        Text("Категория")
                            .font(.caption)
                            .animation(.spring())
                        VStack(alignment: .center, spacing: 10) {
                            
                            ZStack(alignment: .center) {
                                
                                Color("BackgroundColorRow")
                                //                            self.selectType == .all ? Color("Primary") : Color("BackgroundColorRow")
                                
                                Button(action: {
                                    self.selectType = .all
                                }){
                                    HStack(alignment: .center, spacing: 10.0){
                                        Text("Все услуги")
                                            .font(.body)
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        Image(systemName: self.selectType == .all ? "list.dash" : "list.dash")
                                            .font(.body)
                                            .foregroundColor(Color("Primary"))
                                        //self.selectType == .all ? Color("BackgroundColorRow") : Color("Primary"))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal,15)
                                .padding(.vertical,10)
                                
                                
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15).stroke(self.selectType == .all ? Color("Primary") : Color("BackgroundColorRow"), lineWidth: 2)
                            )
                            //                        .border(Color.purple, width: 5, cornerRadius: 15)
                            
                            ZStack(alignment: .center) {
                                
                                self.selectType == .fed ? Color("Primary") : Color("BackgroundColorRow")
                                
                                Button(action: {
                                    self.selectType = .fed
                                }){
                                    HStack(alignment: .center, spacing: 10.0){
                                        Text("Федеральные услуги")
                                            .font(.body)
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        Image(systemName: self.selectType == .fed ? "checkmark" : "chevron.right")
                                            .font(.body)
                                            .foregroundColor(self.selectType == .fed ? Color("BackgroundColorRow") : Color("Primary"))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(15)
                                
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            ZStack(alignment: .center) {
                                
                                self.selectType == .reg ? Color("Primary") : Color("BackgroundColorRow")
                                
                                Button(action: {
                                    self.selectType = .reg
                                }){
                                    HStack(alignment: .center, spacing: 10.0){
                                        Text("Региональные услуги")
                                            .font(.body)
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        Image(systemName: self.selectType == .reg ? "checkmark" : "chevron.right")
                                            .font(.body)
                                            .foregroundColor(self.selectType == .reg ? Color("BackgroundColorRow") : Color("Primary"))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(15)
                                
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            ZStack(alignment: .center) {
                                
                                
                                self.selectType == .mun ? Color("Primary") : Color("BackgroundColorRow")
                                
                                Button(action: {
                                    self.selectType = .mun
                                }){
                                    HStack(alignment: .center, spacing: 10.0){
                                        Text("Муниципальные услуги")
                                            .font(.body)
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        Image(systemName: self.selectType == .mun ? "checkmark" : "chevron.right")
                                            .font(.body)
                                            .foregroundColor(self.selectType == .mun ? Color("BackgroundColorRow") : Color("Primary"))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(15)
                                
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .animation(.spring())
                        Divider()
                            .animation(.spring())
                    }
                    
                    
                    Text(getTitleServices(tp: selectType))
                        .font(.caption)
                    
                    if self.getArray(tp: selectType).filter({"\($0.title.lowercased())".contains(searchText.lowercased()) || searchText.isEmpty}).count == 0 {
                        
                        FoundErrorServices()
                    } else {
                        
                        
                        if self.getArray(tp: selectType).count != 0 {
                            VStack(alignment: .center, spacing: 5) {
                                
                                ForEach(self.getArray(tp: selectType).filter({"\($0.title.lowercased())".contains(searchText.lowercased()) || searchText.isEmpty})) { item in
                                    ServicesItem(item: item, selectType: selectType)
                                }
                            }
                        } else {
                            EmptyServices()
                        }
                    }
                    
                }
                .padding(.horizontal)
            }
            .onAppear(){
                self.isAuth = UserProfileControl.UserStatus()
                                self.fetchData()
            }
            .navigationTitle("Услуги")
            .navigationBarItems(trailing: Group {
                if isAuth {
                    NavigationLink(destination: AddServices()) {
                        Image(systemName: "plus")
                    }
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func fetchData() {
        print("fetchData")
        Firestore.firestore().collection("services").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.arrayServices = documents.compactMap { queryDocumentSnapshot -> ServicesStruct? in
                print(self.arrayServices.count)
                return try? queryDocumentSnapshot.data(as: ServicesStruct.self)
            }
        }
    }
    
    func getArray(tp: ServicesEnum) -> [ServicesStruct] {
        switch tp {
        case .all:
            return arrayServices
        case .fed:
            return arrayServices.filter { $0.type == tp.rawValue }
        case .reg:
            return arrayServices.filter { $0.type == tp.rawValue }
        case .mun:
            return arrayServices.filter { $0.type == tp.rawValue }
        }
    }
    func getTitleServices(tp: ServicesEnum) -> String {
        switch tp {
        case .all:
            return "Список услуг"
        case .fed:
            return "Список федеральных услуг"
        case .reg:
            return "Список региональных услуг"
        case .mun:
            return "Список муниципальных услуг"
        }
    }
}

struct Services_Previews: PreviewProvider {
    static var previews: some View {
        Services()
            .preferredColorScheme(.dark)
    }
}

struct ServicesStructtt: Identifiable {
    let id = UUID()
    var title: String
    var type: ServicesEnum
    var description: String
    var order: Int
}

enum ServicesEnum: String {
    case all = "all"
    case fed = "fed"
    case reg = "reg"
    case mun = "mun"
}


struct ServicesItem: View {
    
    var item: ServicesStruct
    
    var selectType: ServicesEnum
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color("BackgroundColorRow")
            
            Button(action: {
                
            }){
                VStack(alignment: .leading, spacing: 10) {
                    if item.description != "" {
                        HStack(alignment: .center, spacing: 10.0){
                            Image(systemName: "briefcase")
                            Text(item.title)
                                .font(.body)
                                .fontWeight(.regular)
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.body)
                                .foregroundColor(Color("Primary"))
                        }
                        
                        Text(item.description)
                            .font(.caption)
                            .fontWeight(.regular)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        HStack(alignment: .center, spacing: 10.0){
                            Image(systemName: "briefcase")
                            Text("Услуга")
                                .font(.body)
                                .fontWeight(.regular)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.body)
                                .foregroundColor(Color("Primary"))
                        }
                        
                        Text(item.title)
                            .font(.body)
                            .fontWeight(.regular)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    if selectType == .all {
                        HStack(alignment: .center, spacing: 5){
                            Image(systemName: "info.circle.fill")
                                .font(.caption)
                                .foregroundColor(Color("Primary"))
                            Text(self.getTitleSr(tp: ServicesEnum(rawValue: item.type) ?? .all))
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(Color("Primary"))
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(15)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    func getTitleSr(tp: ServicesEnum) -> String {
        switch tp {
        case .all:
            return ""
        case .fed:
            return "Федеральная услуга"
        case .reg:
            return "Региональная услуга"
        case .mun:
            return "Муниципальная услуга"
        }
    }
}

struct FoundErrorServices: View {
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color("BackgroundColorRow")
            
            VStack(alignment: .center, spacing: 10.0){
                
                Text("Упс, ничего не найдено 🤷🏻‍♂️")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                HStack{
                    Text("Повторите поиск или смените категорию")
                        .font(.caption)
                        .fontWeight(.regular)
                    Spacer()
                    Image(systemName: "info.circle.fill")
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


struct EmptyServices: View {
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color("BackgroundColorRow")
            
            HStack(alignment: .center, spacing: 10.0){
                Text("Услуги данного типа\nвременно недоступны")
                    .font(.caption)
                    .fontWeight(.regular)
                
                Spacer()
                Image(systemName: "info.circle.fill")
                    .font(.body)
                    .foregroundColor(Color("Primary"))
                
            }
            .buttonStyle(PlainButtonStyle())
            .padding(15)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
