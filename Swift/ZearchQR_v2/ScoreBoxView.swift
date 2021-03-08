//
//  ScoreBoxView.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-05.
//

import SwiftUI

//
//  ShowMapBox.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-04.
//

import CoreLocation

struct ScoreBoxView: View {
    
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    var onDone: () -> Void = { }
    var onCancel: () -> Void = { }
    var body: some View {
    
        VStack(spacing: 10) {
            if(isShown == true){
                ZStack{
                    AsyncImage(
                        url: URL(string: CurrentRoute.shared.image)!,
                       placeholder: { Text("Loading ...")
                           .fontWeight(.bold)
                           .font(.system(size: 50))
                           .frame(width: 200, height: 100)
                       },image: { Image(uiImage: $0).resizable()})
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 100)
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
                           .font(.system(size: 13.5))
                           .padding(8)
                           .background(RadialGradient(gradient: Gradient(colors: [Color(hue: 0.606, saturation: 0.812, brightness: 1.0, opacity: 0.8), Color(hue: 0.752, saturation: 0.9, brightness: 0.556, opacity: 0.65)]), center: .bottom, startRadius:1, endRadius: 75))
                           .cornerRadius(10)
                           .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                   .stroke(lineWidth: 2)
                                   .foregroundColor(.black)
                           )
                           .foregroundColor(Color(hue: 0.516, saturation: 0.088, brightness: 0.956))
                            .padding(2)
                        Text("Creator - " + CurrentRoute.shared.author)
                        .fontWeight(.bold)
                        .font(.system(size: 8.5))
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
                .frame(height: 110)
                Text(String(format: "%.02f km", CLLocation(latitude: CurrentRoute.shared.startLatitude, longitude: CurrentRoute.shared.startLongitude).distance(from: CLLocation(latitude: CurrentRoute.shared.goalLatitude, longitude: CurrentRoute.shared.goalLongitude))/1000))
                    .frame(height: 10)
                Text("Scoreboard")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.black)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:10)
                    .padding(.bottom, 10)
                    .padding(.top, 7)
                List(api.GameRoutes[CurrentRoute.shared.index].scoreboard) { score in
                    HStack{
                        Text("Rank: \(score.rank)  \(score.name)")
                        Spacer()
                    Text(String(score.time) + " minutes")
                    }
                }
            }
            HStack(spacing: 100) {
                Button(action: {
                    print(CurrentRoute.shared.index)
                    self.isShown = false
                    self.onDone()
                }, label: {
                    Text("Close")
                        .font(.system(size: 25))
                })
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.9, height: screenSize.height * 0.6)
        .background(Color(#colorLiteral(red: 0.5, green: 0.7807898914, blue: 0.9456014037, alpha: 0.7278911565)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), radius: 6, x: -9, y: -9)
        .onAppear(){
            print("Image",CurrentRoute.shared.image)
        }
    }

}

struct ScoreBoxView_Preview: PreviewProvider {
    static var previews: some View {
        ScoreBoxView(isShown: .constant(true))
    }
}
