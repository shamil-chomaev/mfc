//
//  ServicesStruct.swift
//  mfc
//
//  Created by Shamil Chomaev on 06.12.2020.
//

import Foundation
import SwiftUI

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ServicesStruct: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var type: String
    var description: String
    var order: Int
    var provider: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case type
        case description
        case order
        case provider
    }
}

struct SubServicesStruct: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var order: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case order
    }
}
