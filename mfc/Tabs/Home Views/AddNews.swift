//
//  AddNews.swift
//  mfc
//
//  Created by Shamil Chomaev on 25.10.2020.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AddNews: View {
    
    @State var title: String = ""
    @State var description: String = ""
    
    @State var createDate: Date = Date()
    
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
            
            Section(header: Text("Заголовок")) {
                TextField("Text", text: $title)
            }
            
            Section(header: Text("Описание")) {
                TextEditor(text: $description)
            }
            
            Button(action: {
            }, label: {
                Text("Добавить обложку")
            })
            
            
            Section(header: Text("Дата публикации")) {
                DatePicker("Date", selection: $createDate)
            }
            
            
            
            Button(action: {
                self.pushNews(news: NewsPush(title: title,
                                             description: description,
                                             create: Date(),
                                             createUser: "",
                                             visible: true))
            }, label: {
                Text("Отправить новость")
            })
            
            .navigationTitle("Добавить новость")
        }
    }
    
    func pushNews(news: NewsPush) {
        self.firStatus = []
        
        self.firStatus.append(StatusLoad(time: Date(), title: "Подготовка отправки данных"))
        
        if news.title == "" {
            self.firStatus.append(StatusLoad(time: Date(), title: "Ошибка! Отсутствует заголовок", type: .critic))
        } else if news.description == "" {
            self.firStatus.append(StatusLoad(time: Date(), title: "Ошибка! Отсутствует описание", type: .critic))
        } else {
            if Auth.auth().currentUser != nil {
                let uemail = (Auth.auth().currentUser?.email)!
                self.firStatus.append(StatusLoad(time: Date(), title: "Отправка от \(uemail)", type: .good))
                
                Firestore.firestore().collection("news").addDocument(data: ["title": news.title,
                                                                            "description": news.description,
                                                                            "create": news.create,
                                                                            "createUser": uemail,
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

struct AddNews_Previews: PreviewProvider {
    static var previews: some View {
        AddNews()
    }
}

struct StatusLoad: Identifiable {
    let id = UUID()
    var time: Date
    var title: String
    var type: FIRST = .normal
}

struct NewsPush {
    var title: String
    var description: String
    var create: Date
    var createUser: String
    var visible: Bool
}

enum FIRST {
    case normal
    case critic
    case good
}


struct ServicesPush {
    var title: String
    var description: String
    var type: String
    var order: Int
    var provider: String
}
