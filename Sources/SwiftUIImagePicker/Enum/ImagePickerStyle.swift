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
        case .camera: return localizedTakeAPhoto
        case .photoLibrary: return localizedChooseAPhoto
        case .delete: return localizedDelete
        }
    }
}
