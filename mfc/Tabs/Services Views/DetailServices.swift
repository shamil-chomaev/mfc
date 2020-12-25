//
//  DetailServices.swift
//  mfc
//
//  Created by Shamil Chomaev on 12.12.2020.
//

import SwiftUI
import Firebase

struct DetailServices: View {
    
    var item: ServicesStruct = ServicesStruct(id: "", title: "", type: "fed", description: "", order: 0, provider: "")
    
    @State var isAuth: Bool = false
    @State var arrayServices: [SubServicesStruct] = [SubServicesStruct(id: "UID", title: "NT", description: "DT", order: 0)]
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color("Background")
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20){
                    ZStack(alignment: .center) {
                        Color("BackgroundColorRow")
                        
                        VStack(alignment: .leading, spacing: 10){
                            HStack(alignment: .center, spacing: 10.0){
                                Image(systemName: "briefcase")
                                Text("Услуга")
                                    .font(.body)
                                    .fontWeight(.regular)
                                Spacer()
                            }
                            
                            Text(item.title)
                                .font(.body)
                                .fontWeight(.regular)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            if item.description != "" {
                                Text(item.description)
                                    .font(.caption)
                                    .fontWeight(.regular)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            HStack(alignment: .center, spacing: 5){
                                Image(systemName: "mail.stack.fill")
                                    .font(.caption)
                                    .foregroundColor(.gray)
        //                            .foregroundColor(Color("Primary"))
                                Text(item.provider)
                                    .font(.caption)
                                    .fontWeight(.regular)
                                    .foregroundColor(.gray)
                            }
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
                        
                        .padding(15)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    HStack(alignment: .center){
                        Text("Подуслуги")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(Color("SubBackground"))
                        
                        Spacer()
                            Image(systemName: "arrow.down.square.fill")
                                .font(.body)
                                .foregroundColor(Color("SubBackground"))
                    }
                    
                    if self.arrayServices.count != 0 {
                        
                        
                        VStack(alignment: .center, spacing: 5) {
                            
                            ForEach(self.arrayServices.sorted { $0.order < $1.order }) { subItem in
                                SubServicesItem(item: subItem)
//                                    .frame(width: 100, height: 200)
                            }
                        }
                    } else {
//                        FoundErrorServices()
                        EmptyServices()
                    }
                }
            }
            .padding(.horizontal)
            
            
            .onAppear(){
                print(item.id)
                
                self.isAuth = UserProfileControl.UserStatus()
                                self.fetchData()
            }
            .navigationTitle("Услуга")
        }
    }
    
    func fetchData() {
        print("fetchData")
        Firestore.firestore().collection("services").document(item.id ?? "").collection("subs").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            print(arrayServices)
            
            self.arrayServices = documents.compactMap { queryDocumentSnapshot -> SubServicesStruct? in
                print(self.arrayServices.count)
                return try? queryDocumentSnapshot.data(as: SubServicesStruct.self)
            }
        }
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

struct DetailServices_Previews: PreviewProvider {
    static var previews: some View {
        DetailServices()
    }
}



struct SubServicesItem: View {
    
    var item: SubServicesStruct
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color("BackgroundColorRow")
            
           
                VStack(alignment: .leading, spacing: 10) {
                    HStack(){
                        Text("#\(item.order + 1)")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white)
//                            .foregroundColor(Color("Primary"))
                    }
                    .padding(3)
                    .padding(.horizontal, 7)
                    .background(Color("Primary"))
                    .cornerRadius(15)
                    
//                    HStack(){
                        VStack(alignment: .leading, spacing: 10){
                            Text(item.title)
                                .font(.body)
                                .fontWeight(.regular)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(item.description)
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
//                        Spacer()
//                        Image(systemName: "chevron.right")
//                            .font(.body)
//                            .foregroundColor(Color("Primary"))
//                    }
//                    if item.description != "" {
//                        HStack(alignment: .center, spacing: 10.0){
//                            Image(systemName: "briefcase")
//                            Text(item.title)
//                                .font(.body)
//                                .fontWeight(.regular)
//
//
//                        }
//
//                        Text(item.description)
//                            .font(.caption)
//                            .fontWeight(.regular)
//                            .lineLimit(nil)
//                            .fixedSize(horizontal: false, vertical: true)
//                    } else {
//                        HStack(alignment: .center, spacing: 10.0){
//                            Image(systemName: "briefcase")
//                            Text("Услуга")
//                                .font(.body)
//                                .fontWeight(.regular)
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .font(.body)
//                                .foregroundColor(Color("Primary"))
//                        }
//
//                        Text(item.title)
//                            .font(.body)
//                            .fontWeight(.regular)
//                            .lineLimit(nil)
//                            .fixedSize(horizontal: false, vertical: true)
//                    }
//
//                    HStack(alignment: .center, spacing: 5){
                        
//                    }
                }
            
            
            .padding(15)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
