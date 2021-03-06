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
        static var accountKey = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case signUp
        case createSessionId
        case logout
        case getStudentLocations
        case getStudentProfile
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .signUp: return "https://auth.udacity.com/sign-up"
            case .createSessionId: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .getStudentProfile: return Endpoints.base + "/users/\(Auth.accountKey)"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func createSession(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: LoginDetails(username: email, password: password))
        
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body, securedReponse: true) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                
                self.getStudentProfile { success, error in
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, error)
                    }
                }
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
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
        taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: StudentLocationResults.self, securedReponse: false) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getStudentProfile(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentProfile.url, responseType: StudentProfileResponse.self, securedReponse: true) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName

                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func postStudentLocation(mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = StudentLocationRequest(uniqueKey: Auth.accountKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: mapString, mediaURL: mediaUrl, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: StudentLocationResponse.self, body: body, securedReponse: false) { response, error in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // MARK: API request helpers
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, securedReponse: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if securedReponse {
                // Remove security bytes
                let range = 5 ..< data.count
                data = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                attemptErrorParsing(decoder: decoder, errorData: data) { error in
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, securedReponse: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if securedReponse {
                data = removeSecurityBytes(data: data)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                attemptErrorParsing(decoder: decoder, errorData: data) { error in
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func removeSecurityBytes(data: Data) -> Data {
        let range = 5 ..< data.count
        return data.subdata(in: range)
    }
    
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
