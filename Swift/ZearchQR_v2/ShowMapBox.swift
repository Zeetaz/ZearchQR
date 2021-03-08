//
//  ShowMapBox.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-04.
//

import SwiftUI
import CoreLocation
struct MapBoxView: View {
    
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    var onDone: () -> Void = { }
    var onCancel: () -> Void = { }
    
    var body: some View {
    
        VStack(spacing: 10) {
            Text(CurrentRoute.shared.name + "\n " + String(format: "%.02f km", CLLocation(latitude: CurrentRoute.shared.startLatitude, longitude: CurrentRoute.shared.startLongitude).distance(from: CLLocation(latitude: CurrentRoute.shared.goalLatitude, longitude: CurrentRoute.shared.goalLongitude))/1000))
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            if(isShown == true){
                ShowMap()
            }
            HStack(spacing: 100) {
                Button(action: {
                    CurrentRoute.shared.distance = String(format: "%.02f km", CLLocation(latitude: CurrentRoute.shared.startLatitude, longitude: CurrentRoute.shared.startLongitude).distance(from: CLLocation(latitude: CurrentRoute.shared.goalLatitude, longitude: CurrentRoute.shared.goalLongitude))/1000)
                    self.isShown = false
                    self.onDone()
                }, label: {
                    Text("Select")
                        .font(.system(size: 25))
                })

                Button(action: {
                    self.isShown = false
                    self.onCancel()
                }, label: {
                    Text("Cancel")
                        .font(.system(size: 25))
                        .foregroundColor(.red)
                })
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.9, height: screenSize.height * 0.7)
        .background(Color(#colorLiteral(red: 0.1296488047, green: 0.1296488047, blue: 0.1296488047, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 6, x: -9, y: -9)

    }
}

struct MapBoxView_Preview: PreviewProvider {
    static var previews: some View {
        MapBoxView(isShown: .constant(true))
    }
}
