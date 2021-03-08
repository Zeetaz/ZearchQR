//
//  ContentView.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-01.
//

import SwiftUI
import Alamofire

var api = APIData.init(UsersInfo: [UserInfo].init(), GameRoutes: [GameRoute].init())
var fetched = false
class User: ObservableObject {
    @Published var name = ""
    @Published var logged_in = false
    @Published var api_fetched = false
    @Published var busy: Bool = false
    static var shared = User()
}

struct ContentView: View
{
    @ObservedObject var user = User()
    var body: some View
    {
        ZStack{
            //ImagePickerView()
            //MainView(Username: $user.name, logged_in: $user.logged_in)
            //WelcomeView(Username: $user.name, logged_in: $user.logged_in)
            if user.name == "" && user.api_fetched == true && user.logged_in != true
            {
                WelcomeView(Username: $user.name, logged_in: $user.logged_in, busy: $user.busy)
            }
            else if user.name != "" && user.logged_in == true && user.api_fetched == true
            {
                MainView(Username: $user.name, logged_in: $user.logged_in)
            }
        }
        .onAppear()
        {
            fetchAPI2()
                for i in api.UsersInfo
                {
                    if i.userUnique == UIDevice.current.identifierForVendor!.uuidString
                    {
                        if i.loggedIn == true
                        {
                        self.user.name = i.name
                        self.user.logged_in = i.loggedIn
                        break
                        }
                    }
                }
                user.api_fetched = true
        }
        }
    }

struct WelcomeView: View
{
    @Binding var Username: String
    @Binding var logged_in: Bool
    @Binding var busy: Bool
    @State var Username22 = ""
    @State private var isPresented: Bool = false
    @State private var username_taken: Bool = false
    @State private var text: String = ""
    @State private var done: Bool = false
    var body: some View
    {
        ZStack(alignment: .center)
        {
            GeometryReader{ geometry in
                VStack
                {
                    Text("ZearchQR")
                        .font(Font.system(size: 40))
                        .font(.callout)
                        .bold()
                        .position(x: geometry.size.width/2, y: geometry.size.height/2.2)
                    
                    Button(action:
                    {
                        var already_user = false
                        for i in api.UsersInfo
                        {
                            if i.userUnique == UIDevice.current.identifierForVendor!.uuidString && i.name == Username
                            {
                                User.shared.name = i.name
                                already_user = true
                                break
                            }
                        }
                        if already_user == false
                        {
                            self.text = ""
                            self.isPresented = true
                        }
                        else
                        {
                            self.logged_in.toggle()
                        }
                    })
                    {
                    Text("Let's get Zearching!")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
        
                    }
                    .position(x: geometry.size.width/2, y: geometry.size.height/6)
                }
            }
            AZAlert(isShown: $isPresented, onDone: { text in
                self.Username22 = text
                self.done = false
                if Username22 == ""
                {
                    print("NO BUEONO BDY")
    
                }
                else if Username22 != ""
                {
                    
                    for i in api.UsersInfo
                    {
                        print(i.name, Username22)
                        if i.name == Username22 && UIDevice.current.identifierForVendor!.uuidString == i.userUnique && i.loggedIn == false
                        {
                            new_user =  UserInfo(name: Username22, userUnique: UIDevice.current.identifierForVendor!.uuidString, loggedIn: true)
                            uploadUser()
                            Username = Username22
                            self.done.toggle()
                            self.logged_in.toggle()
                            break
                        }
                        else if i.name == Username22 && UIDevice.current.identifierForVendor!.uuidString != i.userUnique
                        {
                            print("YARROOOOOOOOO")
                            username_taken.toggle()
                            self.done.toggle()
                            break
                        }
                    }
                }
                if done == false
                {
                    print("Yupp")
                    new_user =  UserInfo(name: Username22, userUnique: UIDevice.current.identifierForVendor!.uuidString, loggedIn: true)
                    uploadUser()
                    Username = Username22
                    done = true
                    self.logged_in.toggle()
                }
            })
        }
        .alert(isPresented: $username_taken, content: {
            Alert(title: Text("Woops!"), message: Text("This username is taken."), dismissButton: .default(Text("OK")))
        })
    }
}


struct MainView: View {
    @Binding var Username: String
    @Binding var logged_in: Bool
    
    var body: some View {
        NavigationView{
            GeometryReader{geometry in
            ZStack {
                Text("ZearchQR")
                    .font(Font.system(size: 40))
                    .font(.callout)
                    .bold()
                    .position(x: geometry.size.width/2, y: geometry.size.height/10)
                Text(User.shared.name)
                    .font(Font.system(size: 25))
                    .font(.callout)
                    .bold()
                    .position(x: geometry.size.width/2, y: geometry.size.height/5.2)
                NavigationLink(destination: StartGameView()) {
                        Text("Start Playing")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(50)
                            .foregroundColor(.white)
                    }
                .position(x: geometry.size.width/2, y: geometry.size.height/3)
                NavigationLink(destination: ScoreboardView()) {
                        Text("  Scoreboard ")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(50)
                            .foregroundColor(.white)
                    }
                .position(x: geometry.size.width/2, y: geometry.size.height/2.09)
                NavigationLink(destination: ImagePickerView()) {
                        Text("Create Route")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(50)
                            .foregroundColor(.white)
                    }
                .position(x: geometry.size.width/2, y: geometry.size.height/1.6)
                
                NavigationLink(destination: ActivateRouteView()) {
                        Text("     Activate     ")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
    
                            .cornerRadius(50)
                            .foregroundColor(.white)
                    }
                .position(x: geometry.size.width/2, y: geometry.size.height/1.296)
                Button(action:{
                    
                    new_user = UserInfo(name: Username, userUnique: UIDevice.current.identifierForVendor!.uuidString, loggedIn: false)
                    uploadUser()
                    Username = ""
                    fetchAPI2()
                    self.logged_in = false
                })
                {
                    Text("     Sign out     ")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(50)
                        .foregroundColor(.white)
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/1.05)
            }
//            .navigationBarTitle("")
//            .navigationBarBackButtonHidden(true)
//            .navigationBarHidden(true)
        }
        }
        .onAppear()
        {
            CurrentRoute.shared.username = Username
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //selectRoute()
    }
}

