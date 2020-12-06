//
//  AddServices.swift
//  mfc
//
//  Created by Shamil Chomaev on 06.12.2020.
//

import SwiftUI
import Firebase

struct AddServices: View {
    
    @State var title: String = ""
    @State var description: String = ""
    
    @State var select: ServicesEnum = .fed
    @State var firStatus: [StatusLoad] = []
    
    var body: some View {
        //        ScrollView(.vertical, showsIndicators: false) {
        Form(){
            if firStatus.count != 0 {
                Section(header: Text("Статус")) {
                    VStack(alignment: .leading, spacing: 0){
                        ForEach(firStatus) { item in
                            Text("\(dateToString(item.time)): \(item.title)")
                                .font(.caption)
                                .foregroundColor(self.getColor(tp: item.type))
                        }
                    }
                }
            }
//
            Section(header: Text("Основное")) {
                TextField("Заголовок", text: $title)
                TextField("Описание", text: $description)
            }
            
            Section(header: Text("Категория")) {
                Picker("Категория", selection: $select) {
                    Text("Федеральные услуги").tag(ServicesEnum.fed)
                    Text("Региональные услуги").tag(ServicesEnum.reg)
                    Text("Муниципальные услуги").tag(ServicesEnum.mun)
                }
            }
            
            
            
//            Section(header: Text("Дата публикации")) {
//                DatePicker("Date", selection: $createDate)
//            }
//
//
//
            Button(action: {
                self.pushNews(serv: ServicesPush(title: title, description: description, type: select.rawValue, order: 0))
            }, label: {
                Text("Отправить услугу")
            })
            
            Button(action: {
                self.title = ""
                self.description = ""
                self.firStatus = []
            }, label: {
                Text("Очистить")
            })
            
            .navigationTitle("Добавить услугу")
        }
    }
    
    func pushNews(serv: ServicesPush) {
        self.firStatus = []
        
        self.firStatus.append(StatusLoad(time: Date(), title: "Подготовка отправки данных"))
        
        if serv.title == "" {
            self.firStatus.append(StatusLoad(time: Date(), title: "Ошибка! Отсутствует заголовок", type: .critic))
        } else {
            if Auth.auth().currentUser != nil {
                let uemail = (Auth.auth().currentUser?.email)!
                self.firStatus.append(StatusLoad(time: Date(), title: "Отправка от \(uemail)", type: .good))
                
                Firestore.firestore().collection("services").addDocument(data: ["title": serv.title,
                                                                            "description": serv.description,
                                                                            "order": serv.order,
                                                                            "type": serv.type,
                                                                            "visible": true]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        self.firStatus.append(StatusLoad(time: Date(), title: "Error writing document: \(err)", type: .critic))
                    } else {
                        print("Document successfully written!")
                        self.firStatus.append(StatusLoad(time: Date(), title: "Новость опубликована", type: .good))
                    }
                }
                
                
                
                
            } else {
                self.firStatus.append(StatusLoad(time: Date(), title: "Ошибка получения данных о пользователе", type: .critic))
            }
        }
    }
    
    func dateToString(_ inDate: Date) -> String {
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter
        }
        return dateFormatter.string(from: inDate)
    }
    
    func getColor(tp: FIRST) -> Color {
        if tp == .good {
            return Color.green
        } else if tp == .critic {
            return Color.red
        } else {
            return Color.black
        }
    }
}

struct AddServices_Previews: PreviewProvider {
    static var previews: some View {
        AddServices()
    }
}
