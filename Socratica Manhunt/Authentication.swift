//
//  Authentication.swift
//  Socratica Manhunt
//
//  Created by Peter Alpajaro on 10/17/24.
//

// Authentication system works as follows:
// User sends a request to the server to login using their username and password.
// If successful, the server will update the user with a JWT.
// The user can then make requests using this token, which will be recognized by the server as that specific user.

import Foundation

class ServerCommunicator {
    
    // Our JSON Authentication Token.
    private var token: String?
    private var isAuthenticated: Bool = false;
    private var errorMessage: String?
    private var web_socket_manager: WebSocketManager = WebSocketManager()
    
    
    init() {
        
    }
    
    func sendLoginRequest(gamecode: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        print("testing, gamecode = " + gamecode +  " password = " + password)
        
        guard let url = URL(string: "https://socratica-manhunt-server-production.up.railway.app/login") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
            }
        
        // Set up the request to the server.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["gamecode": gamecode, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        print("testing again")
        
        // Make the request to the server.
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("error, no connection to server: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                print ("error, no connection to server")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Check if the response is valid, if so, attempt to parse using JSON.
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let token = json["token"] as? String {
                    DispatchQueue.main.async(execute: {
                        
                        self.token = token;
                        self.isAuthenticated = true;
                        print("Successful Authentication, Connecting to websocket now.")
                        
                        completion(.success(token))
                        // TODO: WEBSOCKET AND TEST
                        self.web_socket_manager.setToken(token: token)
                        self.web_socket_manager.connectWebSocket()
                        
                    });
                    
                    return
                    
                } else {
                        self.errorMessage = "Invalid response from server"
                        print(self.errorMessage ?? "failed write to variable")
                }
                
            } else {
                self.errorMessage = "Invalid username or password"
                print(self.errorMessage ?? "Fail")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"])))
            }
            
        }.resume()
        
    }

    
    
    
}


class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    private var authenticationToken: String = "null"
    
    func connectWebSocket() {
        guard let url = URL(string: "https://socratica-manhunt-server-production.up.railway.app?token=" + authenticationToken) else {return}
        
        var request = URLRequest (url: url)
        request.setValue("Bearer " + authenticationToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        
        receiveMessage()
        
    }
    
    // Sets the token from outside.
    func setToken(token: String) {
        
        
        // TODO: Safety in changing the token.
        self.authenticationToken = token
        
    }
    
    // TODO: Implement this in a seperate thread?
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success (let message):
                switch message {
                case .string(let string):
                    print(string)
                case .data(let data):
                    // TODO: Receive pings from the server for location and send back location data.
                    
                    
                    
                    print(data)
                @unknown default:
                    fatalError()
                }
                
            case .failure(let error):
                print("identified websocket error")
                print(error)
            }
            
            
            
            // Cotinue listening for new messages
            self?.receiveMessage()
        }
        
    }
        
        func sendMessage(_ message: String) {
            let message = URLSessionWebSocketTask.Message.string(message)
            webSocketTask?.send(message) {error in
                if let error = error {
                    print("Error Sending Message \(error)")
                }
            }
        }
        
        // TODO: Implement Connection Close reason
        func closeConnection() {
            webSocketTask?.cancel(with: .goingAway, reason: nil)
            
        }
        
        
        
        // Required URLSessionWebSocketDelegate methods
        func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
            print("WebSocket did close with code \(closeCode), reason: \(String(describing: reason))")
        }
        
        func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
            print("WebSocket did open")
        }
    
}
