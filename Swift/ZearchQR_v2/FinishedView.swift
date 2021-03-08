//
//  FinishedView.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-06.
//

import SwiftUI

struct FinishedView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented:Bool = false
    @State private var ranking = 0
    @State private var scoreboard_new = api.GameRoutes[CurrentRoute.shared.index].scoreboard
    @State private var finnished_time_msg = ""
    @State private var test123123 = ""
    var body: some View{
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
                        Text("Goal!")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .font(.system(size: 33))
                            .position(x: geometry.size.width/2, y: geometry.size.height/20)
                        
                Text(CurrentRoute.shared.distance)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .position(x: geometry.size.width/2, y: geometry.size.height/2.44)
                        Text("                     ")
                            .padding()
                            .background(Color(#colorLiteral(red: 0.3671328671, green: 0.7668038774, blue: 0.9456014037, alpha: 1)))
                            .cornerRadius(50)
                
                Text(finnished_time_msg)
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.black)
                    Text("Congratulations")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 33))
                        .position(x: geometry.size.width/2, y: geometry.size.height/1.6)
                    Text("You made it!")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 33))
                        .position(x: geometry.size.width/2, y: geometry.size.height/1.48)
                
                    Button(action: {
                        var user_ranking = 1
                        var index = 0
                        print(CurrentRoute.shared.finnish_time)
                        var test99 = [Scoreboard]()
                        if scoreboard_new.isEmpty == true
                        {
                            test99.append(Scoreboard(name: CurrentRoute.shared.name, rank: user_ranking, time: (self.test123123 as NSString).doubleValue))
                        }
                        else{
                        for i in scoreboard_new
                        {
                            if (self.test123123 as NSString).doubleValue > i.time
                            {
                                user_ranking += 1                          }
                            if (self.test123123 as NSString).doubleValue < i.time
                            {
                                scoreboard_new[index].rank += 1
                            }
                            index += 1
                        }
                            var counter = 0
                            var index22 = 0
                            var cur_rank = 1
                            while true
                            {
                                if cur_rank == user_ranking
                                {
                                    test99.append(Scoreboard(name: CurrentRoute.shared.name, rank: user_ranking, time: (self.test123123 as NSString).doubleValue))
                                    cur_rank += 1
                                }
                                else
                                {
                                    if scoreboard_new[index22].rank == cur_rank
                                    {
                                    test99.append(scoreboard_new[index22])
                                    index22 += 1
                                    cur_rank += 1
                                    }
                                }

                                counter += 1
                                if counter == (index + 1)
                                {
                                    break
                                }
                                
                                
                            }
                        }
                        

                        
                        
                        
                        print(CurrentRoute.shared.finnish_time)
                        
                        new_route = GameRoute(author: "String", active: true, name: CurrentRoute.shared.name, image: "String", coordinates: new_cordinates, scoreboard: test99)
                        
                        
                        uploadScoreboard()
                        isPresented.toggle()
                    },
                        label: {
                            Text("       Publish        ")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(50)
                                .foregroundColor(.white)
                        })
                        .position(x: geometry.size.width/2, y: geometry.size.height/1.2)
                    }
                }
        .alert(isPresented: $isPresented) {
            Alert(title: Text("Success"), message: Text("Your score has now been uploaded!"), dismissButton: .destructive(Text("Back to home")){
                withAnimation{presentationMode.wrappedValue.dismiss()}
            })
            }
        .onAppear()
        {
            fetchAPI2()
            
            let hours: Int = Int(CurrentRoute.shared.finnish_time)/36000
            let minutes: Int = Int(CurrentRoute.shared.finnish_time) / 60 % 60
            let seconds: Int = Int(CurrentRoute.shared.finnish_time) % 60

            if CurrentRoute.shared.finnish_time < 3600
            {
                self.finnished_time_msg = String(format: "%0.2i:%0.2i", minutes,seconds)
                self.test123123 = String(format: "%0.2i.%0.2i", minutes,seconds)
                
            }
            else if CurrentRoute.shared.finnish_time > 3600
            {
                self.finnished_time_msg = String(format: "%0.2i%:0.2i:%0.2i", hours,minutes,seconds)
            }
            self.scoreboard_new = api.GameRoutes[CurrentRoute.shared.index].scoreboard
        }
    }
}

struct FinishedView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedView()
    }
}
