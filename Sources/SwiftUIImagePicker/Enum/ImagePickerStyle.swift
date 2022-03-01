//
//  File.swift
//  
//
//  Created by Vincent on 01/03/2022.
//

import Foundation

enum ImagePickerStyle:Int, Identifiable, CaseIterable, CustomStringConvertible {
    
    static var allCases:[ImagePickerStyle] {
        return [camera,photoLibrary]
    }
    
    var id:Int {
        return self.rawValue
    }
    
    case camera
    case photoLibrary
    case delete
    
    var description: String {
        switch self {
        case .camera: return "Prendre une photo"
        case .photoLibrary: return "Choisir une photo"
        case .delete: return "Supprimer"
        }
    }
}
