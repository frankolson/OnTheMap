//
//  UdacityClient.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case signUp
        case createSessionId
        case logout
        case getStudentLocations
        
        var stringValue: String {
            switch self {
            case .signUp: return "https://auth.udacity.com/sign-up"
            case .createSessionId: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func createSession(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: LoginDetails(username: email, password: password))
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }

            // Remove security bytes
            let range = 5 ..< data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(SessionResponse.self, from: newData)
                DispatchQueue.main.async {
                    Auth.sessionId = responseObject.session.id
                    completion(true, nil)
                }
            } catch {
                attemptErrorParsing(decoder: decoder, errorData: newData) { error in
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
                return
            } else {
                DispatchQueue.main.async {
                    Auth.sessionId = ""
                    completion(true, nil)
                }
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocations.url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentLocationResults.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }
            } catch {
                attemptErrorParsing(decoder: decoder, errorData: data) { error in
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: API request helpers
    
    class func attemptErrorParsing(decoder: JSONDecoder, errorData: Data, completion: @escaping (Error) -> Void) {
        do {
            let errorResponse = try decoder.decode(UdacityResponse.self, from: errorData)
            DispatchQueue.main.async {
                completion(errorResponse)
            }
        } catch {
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
