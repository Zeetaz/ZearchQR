//
//  StartGameView.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-02.
//

import SwiftUI
import MapKit

//Credits https://github.com/twostraws/CodeScanner
import CodeScanner


class CurrentRoute: ObservableObject {
    @Published var selected = false
    @Published var name = ""
    @Published var image = "https://zearchqr-api.azurewebsites.net/image/Tross%C3%B6%20-%20Utkiken.jpeg"
    @Published var author = ""
    @Published var QR_Scanned = ""
    @Published var startLatitude = 1.1123
    @Published var startLongitude = 1.1123
    @Published var goalLatitude = 1.1123
    @Published var goalLongitude = 1.1123
    @Published var index = 0
    @Published var finnish_time: Double = 0
    @Published var distance = "0.0 km"
    @Published var username = ""
    @State static var shared = CurrentRoute()
}


struct StartGameView: View {
    @State var isSelected = false
    @State var finnished = false
    var body: some View {
        if isSelected == false{
            selecteRoute(isSelected: $isSelected)
        }
        else if isSelected == true && finnished == false
        {
            PlayingView(finnished: $finnished)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        else if isSelected == true && finnished == true
        {
            FinishedView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
}

struct selecteRoute: View {
    //var info : game_routes
    @Binding var isSelected: Bool
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var isPresented: Bool = false
    @State private var isNotActive: Bool = false
    @State private var index = 0
    
    var body: some View {
        ZStack{
        List(api.GameRoutes, id: \.id) { route in
            Button(action: {
                self.index = 0
                for i in api.GameRoutes
                {
                    if i.name == route.name
                    {
                        break
                    }
                    else{
                        self.index += 1
                    }
                }
                CurrentRoute.shared.startLatitude = route.coordinates.startLatitude
                CurrentRoute.shared.startLongitude = route.coordinates.startLongitude
                CurrentRoute.shared.goalLatitude = route.coordinates.goalLatitude
                CurrentRoute.shared.goalLongitude = route.coordinates.goalLongitude
                CurrentRoute.shared.name = route.name
                CurrentRoute.shared.author = route.author
                CurrentRoute.shared.image = route.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                CurrentRoute.shared.index = index
                
                print(CurrentRoute.shared.goalLongitude)
                
                if(route.active){
                    self.isPresented.toggle()
                }
                else{
                    self.isNotActive.toggle()
                }
            })
            {
            ZStack{
             AsyncImage(
                url: URL(string: route.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!,
                placeholder: { Text("")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 50))
                    .frame(width: 350)
                },
                image: { Image(uiImage: $0)
                    .resizable()

                }
             )
             .aspectRatio(contentMode: .fill)
             .frame(height: 200)
             .cornerRadius(10)
             .overlay(
                 Rectangle()
                 .foregroundColor(.black)
                 .cornerRadius(10)
                 .opacity(0.2))
            Text(route.name)
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
                if(!route.active)
                {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.7959183673)))
                    
                }
            }
            }
        }
            MapBoxView(isShown: $isPresented, onDone:{
                CurrentRoute.shared.selected.toggle()
                withAnimation{self.isSelected.toggle()}
            })
        }
        .alert(isPresented: $isNotActive, content: {
            Alert(title: Text(CurrentRoute.self.shared.name), message: Text("This route is not active"), dismissButton: .default(Text("OK")))
        })
        .onAppear(perform: {
            fetchAPI2()
        })
        .navigationBarTitle("Select Route", displayMode: .inline)
    }
    }

struct PlayingView: View{
    @Binding var finnished: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDetail = false
    //@State var timeRemaining = 0
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //@State var running = false

    @State private var startScanned: Bool = false
    @State private var goalScanned: Bool = false
    @State private var RouteCompleted = false
    @State private var niceTry: Bool = false
    @State private var nicetry_message: String = ""
    @State private var isScanningQR: Bool = false
    
    @ObservedObject var locationManager = LocationManager()
    var userLatitude: Double {
        return (locationManager.lastLocation?.coordinate.latitude ?? 0)
    }

    var userLongitude: Double {
        return (locationManager.lastLocation?.coordinate.longitude ?? 0)
    }
    
    @ObservedObject var stopwatch = Stopwatch()
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
        ZStack{
            AsyncImage(
                url: URL(string: CurrentRoute.shared.image)!,
               placeholder: { Text("Loading ...")
                   .fontWeight(.bold)
                   .font(.system(size: 50))
                   .frame(width: 358)
               },image: { Image(uiImage: $0).resizable()})
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(10)
                .overlay(
                    Rectangle()
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .opacity(0.2))
                .padding()
            VStack{
                Text(CurrentRoute.shared.name)
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
                .padding()
                Text("Creator - " + CurrentRoute.shared.author)
                .fontWeight(.bold)
                .font(.system(size: 11.5))
                .padding(8)
                .background(RadialGradient(gradient: Gradient(colors: [Color(hue: 0.606, saturation: 0.812, brightness: 1.0, opacity: 0.8), Color(hue: 0.752, saturation: 0.9, brightness: 0.556, opacity: 0.65)]), center: .bottom, startRadius:1, endRadius: 75))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .foregroundColor(Color(hue: 0.516, saturation: 0.088, brightness: 0.956))
            }
        }
            .position(x: geometry.size.width/2, y: geometry.size.height/4)
                Text("Good luck!")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .font(.system(size: 33))
                    .position(x: geometry.size.width/2, y: geometry.size.height/20)
                
                Text(String(format: "%.02f km", CLLocation(latitude: CurrentRoute.shared.startLatitude, longitude: CurrentRoute.shared.startLongitude).distance(from: CLLocation(latitude: CurrentRoute.shared.goalLatitude, longitude: CurrentRoute.shared.goalLongitude))/1000))
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .position(x: geometry.size.width/2, y: geometry.size.height/2.44)
//            Text("\(timeString(time: timeRemaining))")
//                        .font(.system(size: 60))
//                        .frame(height: 80.0)
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(Color.black)
//                        .onReceive(timer){ _ in
//                            if running == true {
//
//                                self.timeRemaining += 1
//                            }
//                            else if temp_toRun == 2
//                            {
//                                self.timer.upstream.connect().cancel()
//                            }
//                        }
//
                Text("                     ")
                    .padding()
                    .background(Color(#colorLiteral(red: 0.3671328671, green: 0.7668038774, blue: 0.9456014037, alpha: 1)))
                    .cornerRadius(50)
                if stopwatch.message != ""
                {
                Text(verbatim: stopwatch.message)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.black)
                }
                else
                {
                    Text("00.00")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.black)
                }
                
            NavigationLink(
                destination: ShowMap(),
                label: {
                    Text("Show Route")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.orange]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
                })
                .position(x: geometry.size.width/2, y: geometry.size.height/1.3)
                
            Button(action: {
                self.isScanningQR = true
            },
                label: {
                    Text("  Scann QR   ")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.orange]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
                })
                .position(x: geometry.size.width/2, y: geometry.size.height/1.6)
            
            Button(action: {
                stopwatch.stop()
                presentationMode.wrappedValue.dismiss()
            },
                label: {
                    Text("       Abort        ")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
                })
                .position(x: geometry.size.width/2, y: geometry.size.height/1.1)
            }
            .alert(isPresented: $niceTry) {
                Alert(title: Text("QRScanner"), message: Text(nicetry_message))
                }

        .sheet(isPresented: $isScanningQR, onDismiss:{
            if startScanned == true && goalScanned == true
            {
                withAnimation{self.finnished.toggle()}
            }
            else
            {
                self.niceTry.toggle()
            }
        }) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Test12345", completion: self.handleScan)
        }
        }
    }
//    func timeString(time: Int) -> String
//    {
//        let hours   = Int(time) / 3600
//        let minutes = Int(time) / 60 % 60
//        let seconds = Int(time) % 60
//        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
//    }
    
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isScanningQR = false
        switch result {
        case .success(let code):
            let details = code
            guard !details.isEmpty else { return }
            
            let distance_meters_goal = CLLocation(latitude: userLatitude, longitude: userLongitude).distance(from: CLLocation(latitude: CurrentRoute.shared.goalLatitude, longitude: CurrentRoute.shared.goalLongitude))
            let distance_meters_start = CLLocation(latitude: userLatitude, longitude: userLongitude).distance(from: CLLocation(latitude: CurrentRoute.shared.startLatitude, longitude: CurrentRoute.shared.startLongitude))
            if details == CurrentRoute.shared.name
            {
                if startScanned == true
                {
                    if distance_meters_goal < 100
                    {
                        CurrentRoute.shared.finnish_time = stopwatch.time_sec
                        self.stopwatch.stop()
                        self.goalScanned.toggle()
                        self.nicetry_message = "Congratulations! \n You made it! "
                    }
                    else
                    {
                        self.nicetry_message = "Nice try, but you can't cheat!"

                    }
                }
                else if startScanned != true
                {
                    if distance_meters_start < 100
                    {
                        
                        self.stopwatch.start()
                        self.startScanned.toggle()
                        self.nicetry_message = "Hurry! The time is ticking..."
                    }
                    else{
                        self.nicetry_message = "Please go to the correct start location!"
                    }
                }
            }
            else
            {
                self.nicetry_message = "You're scanning the wrong route..."
            }
            
        case .failure(let error):
            print("Scanning failed", error)
        }
        
    }

}



struct MapViewUIKit: UIViewRepresentable {
    let region: MKCoordinateRegion
    let mapType : MKMapType
    
    func makeCoordinator() -> MapViewCoordinator {
      return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.mapType = mapType
        
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CurrentRoute.shared.startLatitude, longitude: CurrentRoute.shared.goalLongitude))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CurrentRoute.shared.goalLatitude, longitude: CurrentRoute.shared.startLongitude))
        
        let request = MKDirections.Request()
          request.source = MKMapItem(placemark: p1)
          request.destination = MKMapItem(placemark: p2)
          request.transportType = .walking

          let directions = MKDirections(request: request)
          directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([p1, p2])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
              route.polyline.boundingMapRect,
              edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30),
              animated: true)
          }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.mapType = mapType
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
      func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
      }
    }
}

struct ShowMap: View {
    // 1
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56.16156, longitude: 15.58661) , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    // 2
    @State private var mapType: MKMapType = .standard
        
    var body: some View {
        ZStack {
            // 3
            MapViewUIKit(region: region, mapType: mapType)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // 4
                Picker("", selection: $mapType) {
                    Text("Standard").tag(MKMapType.standard)
                    Text("Satellite").tag(MKMapType.satellite)
                    Text("Hybrid").tag(MKMapType.hybrid)
                }
                .pickerStyle(SegmentedPickerStyle())
                .offset(y: -40)
                .font(.largeTitle)
            }
        }
    }
}
//
//struct DetailView: View {
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//    var body: some View {
//        Capsule()
//            .fill(Color.secondary)
//            .frame(width: 30, height: 3)
//            .padding(10)
//
//        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
//    }
//}


struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        PlayingView(finnished: .constant(false))
    }
}
