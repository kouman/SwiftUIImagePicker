//
//  File.swift
//  
//
//  Created by Vincent on 01/03/2022.
//

import SwiftUI
import Combine

struct ImagePickerViewModel {
    var image:UIImage?
    var publisher = PassthroughSubject<UIImage?, Never>()
}
