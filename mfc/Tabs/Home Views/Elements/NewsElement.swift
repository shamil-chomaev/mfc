//
//  NewsElement.swift
//  mfc
//
//  Created by Bela in team Shamil Chomaev on 25.10.2020.
//

import SwiftUI

struct NewsElement: View {
    
    var item: NewsStruct
    
    @State private var scaleValue = CGFloat(1)
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            GeometryReader(content: { geometry in
                
                RemoteImage(url: "\(item.imageUrl)")
                    
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.width)
            })
        
            Color.black.opacity(0.25)
            
            VStack(alignment: .leading, spacing: 10){
                HStack(){
                    Text(self.dateToString(item.create))
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(Color.white)

                    Spacer()
                    Text("\(item.createUser)")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(Color.white)
                }
                Spacer()
                
                Text(item.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(Color.white)
                Text(item.description)
                    .font(.body)
                    .fontWeight(.regular)
                    .lineLimit(3)
                    .foregroundColor(Color.white)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .scaleEffect(self.scaleValue)
        .shadow(radius: 5)
    }
    
    func dateToString(_ inDate: Date) -> String {
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy" //HH:mm
            return formatter
        }
        return dateFormatter.string(from: inDate)
    }
    
}



struct NewsElement_Previews: PreviewProvider {
    static var previews: some View {
        NewsElement(item: NewsStruct(title: "Тестовая новость",
                                   description: "To fetch data from Firestore, you’ll first have to connect your app to Firebase. I’m not going to go into great detail about this here - if you’re new to Firebase (or your background is in Android or web development), check out this video which will walk you through the process (don’t worry, it’s not very complicated).",
                                   imageUrl: "https://wylsa.com/wp-content/uploads/2020/10/iphone-12-pro-1.jpg",
                                   create: Date(),
                                   createUser: "sham.chom77@gmail.com",
                                   visible: true))
            .padding()
    }
}
