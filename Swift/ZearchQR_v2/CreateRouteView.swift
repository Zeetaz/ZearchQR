//
//  CreateRouteView.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-03.
//

import SwiftUI
import CodeScanner

struct ActivateRouteView: View {
    @State var route_name: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var scanned = false
    @State private var isScanningQR = false
    @State private var which_one = ""
    @State var uploadChanges = false
    
    @ObservedObject var locationManager = LocationManager()

    var userLatitude: Double {
        return (locationManager.lastLocation?.coordinate.latitude ?? 0)
    }

    var userLongitude: Double {
        return (locationManager.lastLocation?.coordinate.longitude ?? 0)
    }
    
    
    var body: some View {
        GeometryReader{geometry in
                Text("ZearchQR")
                    .font(Font.system(size: 40))
                    .font(.callout)
                    .bold()
                    .position(x: geometry.size.width/2, y: geometry.size.height/10)
                
                Text("Place QR code at \"Start\"")
                    .font(Font.system(size: 30))
                    .font(.callout)
                    .bold()
                    .position(x: geometry.size.width/2, y: geometry.size.height/4)
                
                Text("Scann the QR code")
                    .font(Font.system(size: 30))
                    .font(.callout)
                    .bold()
                    .position(x: geometry.size.width/2.49, y: geometry.size.height/3)
            
                Text("Place QR code at \"Goal\"")
                    .font(Font.system(size: 30))
                    .font(.callout)
                    .bold()
                    .position(x: geometry.size.width/2.05, y: geometry.size.height/1.6)
            
                Text("Scann the QR code")
                    .font(Font.system(size: 30))
                    .font(.callout)
                    .bold()
                    .position(x: geometry.size.width/2.49, y: geometry.size.height/1.42)

                Button(action:{
                    //openURL(URL(string: "https://zearchqr-api.azurewebsites.net/qr/"+test123)!)
                    self.which_one = "Start"
                    fetchAPI2()
                    self.isScanningQR.toggle()
                })
                {
                    Text("     Activate Start     ")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/2.10)
            
            Button(action:{
                //openURL(URL(string: "https://zearchqr-api.azurewebsites.net/qr/"+test123)!)
                self.which_one = "Goal"
                fetchAPI2()
                self.isScanningQR.toggle()
            })
            {
                Text("     Activate Goal     ")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(50)
                    .foregroundColor(.white)
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/1.17)
        }
        .alert(isPresented:$scanned) {
            Alert(title: Text(which_one + " has been activated"))
        }
        
        .sheet(isPresented: $isScanningQR, onDismiss:{ self.scanned.toggle()})
        {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Test12345", completion: self.handleScan)
            }
    }
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isScanningQR = false
        self.uploadChanges = false
        switch result {
        case .success(let code):
            let details = code
            guard !details.isEmpty else { return }
            print(details)
            for i in api.GameRoutes
            {
                print(i.name)
            }
            for i in api.GameRoutes
            {
                if i.name == details && i.active == false
                {
                    new_route = i
                    if !i.active
                    {
                        if(which_one == "Start" && i.coordinates.startSet == false)
                        {
                            print("STAAAAAAAAAAAAAART")
                            new_route.coordinates.startLatitude = userLatitude
                            new_route.coordinates.startLongitude = userLongitude
                            new_route.coordinates.startSet = true
                            self.uploadChanges.toggle()
                        }
                        else if (which_one == "Goal" && i.coordinates.goalSet == false)
                        {
                            print("GOOOOOOOOOOOOOAL")
                            new_route.coordinates.goalLatitude = userLatitude
                            new_route.coordinates.goalLongitude = userLongitude
                            new_route.coordinates.goalSet = true
                            self.uploadChanges.toggle()
                        }
                        if new_route.coordinates.goalSet == true && new_route.coordinates.startSet == true
                        {
                            new_route.active = true
                            if !uploadChanges
                            {self.uploadChanges.toggle()}
                        }
                        if uploadChanges
                        {
                            uploadNewRoute()
                        }
                    }
                    break
                }
            }
            CurrentRoute.shared.QR_Scanned = details
            
        case .failure(let error):
            print("Scanning failed", error)
            
            
        }
    }
}


//struct CreateRouteView_Previews: PreviewProvider {
//    static var previews: some View {
//        //CreateRouteView()
//        //ActivateRouteView()
//    }
//}
