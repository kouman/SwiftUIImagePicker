//
//  ImagePicker.swift
//  Form
//
//  Created by Vincent on 17/07/2020.
//

import SwiftUI
import UIKit
import Combine

struct ImageCameraPickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool

    var model: ImagePickerViewModel
    
    init(isPresented:Binding<Bool>, model: ImagePickerViewModel) {
        self._isPresented = isPresented
        self.model = model
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageCameraPickerView>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImageCameraPickerView>) {}
}

extension ImageCameraPickerView {
    
    class Coordinator: NSObject, UINavigationControllerDelegate {
        var parentView: ImageCameraPickerView
        init(_ parentView: ImageCameraPickerView) {
            self.parentView = parentView
        }
    }
}

extension ImageCameraPickerView.Coordinator: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uiImage = info[.originalImage] as? UIImage,
           let fixedOrientation = uiImage.fixOrientation() {
            parentView.model.publisher.send(fixedOrientation.cropsToSquare())
            parentView.isPresented = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parentView.isPresented = false
    }
}
