//
//  ScoreboardView.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-03.
//

import SwiftUI

import Alamofire

struct ScoreboardView: View {
    @State private var isPresented: Bool = false
    @State var index = 0
    var body: some View {
        ZStack(alignment: .center)
        {
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
 
                self.isPresented.toggle()
            }, label: {
                ZStack{
                 AsyncImage(
                    url: URL(string: route.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!,
                    placeholder: { Text("")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 50))
                        .frame(width: 358)
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
            })
        }
        .navigationBarTitle("Scoreboard", displayMode: .inline)
        //.edgesIgnoringSafeArea(.all)
        ScoreBoxView(isShown: $isPresented)
        }
        .onAppear(){
            fetchAPI2()
        }
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}
