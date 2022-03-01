//
//  SwiftUIView.swift
//  
//
//  Created by Vincent on 01/03/2022.
//
import SwiftUI
import Combine

public struct SwiftUIImagePickerView<Content:View>: View {
    
    private var imagePickerViewModel:ImagePickerViewModel = ImagePickerViewModel()
    
    private var content: ()->Content
    
    @State private var showingOptions:Bool = false
    
    @State private var isPresented:Bool = false
    
    @State private var showingAlert:Bool = false
    
    @State private var pickerStyle:ImagePickerStyle?
    
    @Binding private var image:UIImage?
    
    public init(image:Binding<UIImage?>, @ViewBuilder content: @escaping ()->Content) {
        self._image = image
        self.content = content
    }
    
    public var body: some View {
        
        content()
        
        .onTapGesture {
            handleTap()
        }
        
        .actionSheet(isPresented: self.$showingOptions) {
            generateActionSheet()
        }
        
        .sheet(isPresented: self.$isPresented) {
            container()
        }

        .alert(TITLE, isPresented: $showingAlert) {
            alert()
        }
    
        .onReceive(imagePickerViewModel.publisher) { image in
            self.image = image
        }
    }
    
    private func handleTap() {
        UIApplication.shared.endEditing()
        self.showingOptions.toggle()
    }
    
    @ViewBuilder
    private func container() -> some View {
        switch pickerStyle {
        case .camera: ImagePhotoLibraryPickerView(isPresented: self.$isPresented, model: imagePickerViewModel)
        case .photoLibrary: ImageCameraPickerView(isPresented: self.$isPresented, model: imagePickerViewModel)
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
            buttons.append(Alert.Button.default(Text(btn.description)) {self.pickerStyle = btn})
        }
        if let _ = image {
            buttons.append(Alert.Button.default(Text(ImagePickerStyle.delete.description)) {self.showingAlert.toggle()})
        }
        buttons.append(Alert.Button.cancel(Text(CANCEL)))
        return ActionSheet(title: Text(OPTIONS), buttons: buttons)
    }
}
