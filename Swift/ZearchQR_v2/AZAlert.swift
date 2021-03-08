//
//  AZAlert.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-01.
//

//Credits to Mohammad Azam who posted a nice tutorial httwww.youtube.com/watch?v=sOoFBB0VVKI
//I've modified it slightly and created different adaptations of it

import SwiftUI

struct AZAlert: View {
    @Binding var isShown: Bool
    let screenSize = UIScreen.main.bounds
    @State var text = ""
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    
    var body: some View {
    
        VStack(spacing: 10) {
            Text("Login")
                .font(.headline)
            Text("Select a Username")
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 20) {
                Button("Done") {
                    self.isShown = false
                    self.onDone(self.text)
                }
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.22)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)

    }
}

//struct AZAlert_Previews: PreviewProvider {
//    static var previews: some View {
//        AZAlert(title: "Add Item", isShown: .constant(true), text: .constant(""))
//    }
//}
