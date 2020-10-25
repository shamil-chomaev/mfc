//
//  NewsStruct.swift
//  mfc
//
//  Created by Shamil Chomaev on 25.10.2020.
//

import Foundation
import SwiftUI

import FirebaseFirestore
import FirebaseFirestoreSwift


struct NewsStruct: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var imageUrl: String
    var create: Date
    var createUser: String
    var visible: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl
        case create
        case createUser
        case visible
    }
}
