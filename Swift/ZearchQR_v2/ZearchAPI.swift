//
//  ZearchAPI.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-01.
//
//  Many many various guides/tutorials has been used to create these. Not sure where the final version was most inspired from though. All have been changed as well.

import Foundation

// MARK: - Welcome
struct APIData: Codable {
    let UsersInfo: [UserInfo]
    var GameRoutes: [GameRoute]

    enum CodingKeys: String, CodingKey {
        case UsersInfo
        case GameRoutes
    }
}

// MARK: - GameRoute
struct GameRoute: Codable, Identifiable {
    let id = UUID()
    let author: String
    var active: Bool
    let name: String
    let image: String
    var coordinates: Coordinates
    var scoreboard: [Scoreboard]
}

// MARK: - Coordinates
struct Coordinates: Codable {
    var startLatitude, startLongitude, goalLatitude, goalLongitude: Double
    var startSet, goalSet: Bool
}

// MARK: - UsersInfo
struct UserInfo: Codable {
    let name, userUnique: String
    let loggedIn: Bool
}

struct Scoreboard: Codable, Identifiable {
    let id = UUID()
    var name: String
    var rank: Int
    var time: Double
}






func fetchAPI2()
{
    let sem = DispatchSemaphore.init(value: 0)
    
    if let url = URL(string: "https://zearchqr-api.azurewebsites.net/all_data"){
            let session = URLSession.shared
            session.dataTask(with: url) {(data, response, err) in
            guard let jsonData = data else { return }
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let info = try decoder.decode(APIData.self, from: jsonData)
                api = info
                defer { sem.signal() }
            } catch let jsonErr {
                print("Error decoding JSON", jsonErr)
            }
        }
            .resume()
        sem.wait()
        
    }
}


var image_url_address : String = ""
func uploadImageAPI(){
    let escapedString = image_url_address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    print(escapedString!)
    let url = URL(string: escapedString!)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.uploadTask(with: request, from: test) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }

        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
        }
    }
    task.resume()
}

var new_scoreboard = [Scoreboard(name: "EMPTY", rank: 1, time: 1.0)]
var new_cordinates = Coordinates(startLatitude: 1.0, startLongitude: 1.0, goalLatitude: 1.0, goalLongitude: 1.0, startSet: false, goalSet: false)
var new_route = GameRoute(author: "bettan", active: false, name: "route_name", image: "iamge_url", coordinates: new_cordinates, scoreboard: new_scoreboard)
func uploadNewRoute(){
    guard let uploadData = try? JSONEncoder().encode(new_route) else {
        print("ERROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOR")
        return
    }
    print(uploadData)
    let url = URL(string: "https://zearchqr-api.azurewebsites.net/add_route")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
        }
    }
    task.resume()
    
}
var new_user = UserInfo(name: "", userUnique: "", loggedIn: false)
func uploadUser(){
    let sem = DispatchSemaphore.init(value: 0)
    guard let uploadData = try? JSONEncoder().encode(new_user) else {
        return
    }
    print(uploadData)
    let url = URL(string: "https://zearchqr-api.azurewebsites.net/add_user")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
            defer { sem.signal() }
        }
    }
    task.resume()
    sem.wait()
}


func uploadScoreboard(){
    let sem = DispatchSemaphore.init(value: 0)
    guard let uploadData = try? JSONEncoder().encode(new_route) else {
        return
    }
    print(uploadData)
    let url = URL(string: "https://zearchqr-api.azurewebsites.net/add_score")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
            defer { sem.signal() }
        }
    }
    task.resume()
    sem.wait()
}
