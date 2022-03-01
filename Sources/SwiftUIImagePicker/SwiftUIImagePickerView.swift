//
//  SwiftUIView.swift
//  
//
//  Created by Vincent on 01/03/2022.
//
import SwiftUI
import Combine

class SwiftUIImagePickerViewObserver:ObservableObject {
    @Published var showingOptions:Bool = false
    @Published var showingAlert:Bool = false
    @Published var isPresented:Bool = false
    var pickerStyle:ImagePickerStyle? {
        didSet {
            self.isPresented.toggle()
        }
    }
}

public struct SwiftUIImagePickerView<Content:View>: View {
    
    @ObservedObject private var swiftUIImagePickerViewObserver:SwiftUIImagePickerViewObserver = SwiftUIImagePickerViewObserver()
    
    @Binding private var image:UIImage?
    
    private var imagePickerViewModel:ImagePickerViewModel = ImagePickerViewModel()
    
    private var content: ()->Content
    
    public init(image:Binding<UIImage?>, @ViewBuilder content: @escaping ()->Content) {
        self._image = image
        self.content = content
    }
    
    public var body: some View {
        
        content()
        
        .onTapGesture {
            handleTap()
        }
        
        .actionSheet(isPresented: self.$swiftUIImagePickerViewObserver.showingOptions) {
            generateActionSheet()
        }
        
        .sheet(isPresented: self.$swiftUIImagePickerViewObserver.isPresented) {
            container()
        }

        .alert(TITLE, isPresented: $swiftUIImagePickerViewObserver.showingAlert) {
            alert()
        }
    
        .onReceive(imagePickerViewModel.publisher) { image in
            self.image = image
        }
    }
    
    private func handleTap() {
        UIApplication.shared.endEditing()
        self.swiftUIImagePickerViewObserver.showingOptions.toggle()
    }
    
    @ViewBuilder
    private func container() -> some View {
        switch swiftUIImagePickerViewObserver.pickerStyle {
        case .camera: ImagePhotoLibraryPickerView(isPresented: self.$swiftUIImagePickerViewObserver.isPresented, model: imagePickerViewModel)
        case .photoLibrary: ImageCameraPickerView(isPresented: self.$swiftUIImagePickerViewObserver.isPresented, model: imagePickerViewModel)
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    private func alert() -> some View {
        Button(role: .destructive) {self.image = nil} label: {Text(YES)}
        Button(role: .cancel) {} label: { Text(NO) }
    }
    
    private func generateActionSheet() -> ActionSheet {
        var buttons = [ActionSheet.Button]()
        ImagePickerStyle.allCases.forEach { btn in
            buttons.append(Alert.Button.default(Text(btn.description)) {
                self.swiftUIImagePickerViewObserver.pickerStyle = btn
            })
        }
        if let _ = image {
            buttons.append(Alert.Button.default(Text(ImagePickerStyle.delete.description)) {self.swiftUIImagePickerViewObserver.showingAlert.toggle()})
        }
        buttons.append(Alert.Button.cancel(Text(CANCEL)))
        return ActionSheet(title: Text(OPTIONS), buttons: buttons)
    }
}
