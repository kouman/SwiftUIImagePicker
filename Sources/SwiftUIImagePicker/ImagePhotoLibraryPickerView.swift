//
//  ImagePickerView.swift
//  App Onboarding
//
//  Created by Vincent on 13/12/2019.
//  Copyright © 2019 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct ImagePhotoLibraryPickerView : UIViewControllerRepresentable {

    @Binding private var isPresented:Bool
    
    private var model: ImagePickerViewModel

    init(isPresented: Binding<Bool>, model:ImagePickerViewModel) {
        self._isPresented = isPresented
        self.model = model
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        controller.mediaTypes = ["public.image"]
        controller.sourceType = .camera
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePhotoLibraryPickerView>) {
        // run right after making
    }

    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parentView: ImagePhotoLibraryPickerView

        init(_ parentView: ImagePhotoLibraryPickerView) {
            self.parentView = parentView
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parentView.isPresented = false
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage, let fixedOrientation = uiImage.fixOrientation() {
                parentView.model.publisher.send(fixedOrientation.cropsToSquare())
                parentView.isPresented = false
            } 
        }
    }
}
