//
//  ImagePickerView.swift
//  ZearchQR_v2
//
//  I've forgotten where I found the "howImagePicker" implementation, either it was a youtube tutorial or an open-source git project...
//  Eitherway it was free to use, it helps with allowing the user to select images using this "image picker". The Struct view is all me though.
//

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var isShown    : Bool
    @Binding var image      : Image?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}







var test = Data()

class ImagePickerCordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @Binding var isShown    : Bool
    @Binding var image      : Image?
    
    init(isShown : Binding<Bool>, image: Binding<Image?>) {
        _isShown = isShown
        _image   = image
    }
    
    //Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = Image(uiImage: uiImage)
        test = uiImage.compress(to: 1000)
        print(test)
        
        isShown = false
    }
    
    //Image selection got cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}




extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        guard kb > 10 else { return Data() } // Prevents user from compressing below a limit (10kb in this case).
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            guard let data = holderImage.jpegData(compressionQuality: 1.0) else { break }
            let ratio = data.count / bytes
            if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                complete = true
                return data
            } else {
                let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                compression -= (step * multiplier)
            }
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        
        return Data()
    }
}
 




struct ImagePickerView: View {
    
    @State private var showImagePicker : Bool = false
    @State private var image : Image? = nil
    @State private var route_name: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var created = false
    var body: some View {
        GeometryReader{geometry in
            Text("ZearchQR")
                .font(Font.system(size: 40))
                .font(.callout)
                .bold()
                .position(x: geometry.size.width/2, y: geometry.size.height/10)
                ZStack{
                    if image == nil
                    {
                        Image("basic")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .overlay(
                                Rectangle()
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .opacity(0.2))
                            .padding()
                            .position(x: geometry.size.width/2, y: geometry.size.height/3)
                    }
                    else{
                        image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .overlay(
                            Rectangle()
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .opacity(0.2))
                            .padding()
                            .position(x: geometry.size.width/2, y: geometry.size.height/3)
                        }
                    if(route_name != ""){
                    Text(route_name)
                        .fontWeight(.bold)
                        .font(.system(size: 20.5))
                        .padding(8)
                        .background(RadialGradient(gradient: Gradient(colors: [Color(hue: 0.606, saturation: 0.812, brightness: 1.0, opacity: 0.8), Color(hue: 0.752, saturation: 0.9, brightness: 0.556, opacity: 0.65)]), center: .bottom, startRadius:1, endRadius: 75))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black)
                        )
                        .foregroundColor(Color(hue: 0.516, saturation: 0.088, brightness: 0.956))
                        .position(x: geometry.size.width/2, y: geometry.size.height/3)
                    }
                }
            
            Text(" 1. Select a picture \n 2. Enter a name for you route \n 3. Generate a QR code")
                .font(Font.system(size: 25))
                .font(.callout)
                .bold()
                .position(x: geometry.size.width/2.1, y: geometry.size.height/1.7)
            HStack{
                Button(action: {self.showImagePicker.toggle()}, label: {
                    Text("Select Picture")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
                })
                Button(action: {
                    if(route_name != "")
                    {
                        let qr_create_url = "https://zearchqr-api.azurewebsites.net/qr/" + route_name
                        UIApplication.shared.open(URL(string: qr_create_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!){
                            launched in
                            if launched{
                                    image_url_address = "https://zearchqr-api.azurewebsites.net/imageupload/" + route_name + ".jpeg"
                                    new_route = GameRoute(author: "Zedd", active: false, name: route_name, image: "https://zearchqr-api.azurewebsites.net/image/" + route_name + ".jpeg", coordinates: new_cordinates, scoreboard: new_scoreboard)
                                    uploadImageAPI()
                                    uploadNewRoute()
                                    self.created.toggle()
                                    self.mode.wrappedValue.dismiss()
                            }
                        }
                    }
                    
                }, label: {
                    Text("  Generate QR  ")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
                })
            }
                .position(x: geometry.size.width/2, y: geometry.size.height/1.1)
                
            TextField("Enter your route name...", text: $route_name)
                .padding(.all, 20.0)
                .background(Color.gray)
                .cornerRadius(20)
                .foregroundColor(Color(.black))
                .padding(.horizontal, 50)
                .position(x: geometry.size.width/2, y: geometry.size.height/1.35)
            
            .sheet(isPresented: self.$showImagePicker){
                PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
            }
        }
        .navigationBarTitle("Create Route", displayMode: .inline)
        .alert(isPresented:$created) {
            Alert(title: Text("Route has been successfully created"), message: Text("Please go to \"Active\" to activate the new route"))
        }
    }
    
    
}

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker    : Bool
    @Binding var image              : Image?
    
    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image)
    }
}

//struct PhotoCaptureView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(Image("")))
//    }
//}
struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}
