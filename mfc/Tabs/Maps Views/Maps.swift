//
//  Maps.swift
//  mfc
//
//  Created by Shamil Chomaev on 03.12.2020.
//

import MapKit
import SwiftUI

struct Maps: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.764400, longitude: 41.896700), span: MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75))

        var body: some View {
            NavigationView{
                Button(action: {
                    self.ddff()
                }, label: {
                    Text("Button")
                })
//                ScrollView(.vertical, showsIndicators: true){
//
//                    VStack {
//                        Text("Тут будет текст")
//                    }
//                }
                
                Map(coordinateRegion: $region)
                .navigationTitle("На карте")
            }
            
        }
    
    func ddff() {
        let items = [["com.instagram.sharedSticker.backgroundTopColor": "#EA2F3F", "com.instagram.sharedSticker.backgroundBottomColor": "#8845B9"]]
        
        // 1
        if let urlScheme = URL(string: "instagram-stories://share") {
            
            // 2
            if UIApplication.shared.canOpenURL(urlScheme) {
                
                // 3
                let imageData: Data = UIImage(imageLiteralResourceName: "doc.fill").pngData()!
                
                // 4
                let items = [["com.instagram.sharedSticker.backgroundImage": imageData]]
                let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]
                
                // 5
                UIPasteboard.general.setItems(items, options: pasteboardOptions)
                
                // 6
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
            }
        }
    }
    
}

struct Maps_Previews: PreviewProvider {
    static var previews: some View {
        Maps()
    }
}
