//
//  ContentView.swift
//  Socratica Manhunt
//
//  Created by Peter Alpajaro on 10/17/24.
//

import SwiftUI
import MapKit





var fontSelection =  "Futura"
var emergencyMessage = "Game Paused: Please Wait"

// Called by main function
struct ContentView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        
        if (userManager.isLoggedIn == false) {
            
            LoginView()
            
        } else {
            
            MainView()
            
        }
            
    }
    
    
}
// Login Screen
struct LoginView: View {
    @State private var gameCode: String = ""
    @State private var gamePass: String = ""
    @State private var loginFailed: Bool = false
    @State private var isAuthenticated = false
    @State private var login_manager: ServerCommunicator?
    
    // This lets us access the user manager
    @EnvironmentObject var userManager: UserManager
    
    
    var body: some View {
        
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Game Code", text: $gameCode)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            
            TextField("Password", text: $gamePass)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            
            // Login Failure Message
            if (loginFailed) {
                Text("Game Code or Password Invalid")
                    .foregroundColor(.red)
                    .padding()
                
            }
            
            // Login Button
            Button(action: {
                // TODO: Disable button
                
                // TODO: Server setup and testing
                login_manager = ServerCommunicator()
                login_manager?.sendLoginRequest(gamecode: gameCode, password: gamePass) { result in
                    switch result {
                    case .success(let token):
                        print("Successful, \(token)")
                        userManager.isLoggedIn = true
                    case .failure(let error):
                        print("Fail, \(error.localizedDescription)")
                        
                    }
                }
                
                // TODO: Reenable Button if Failure
                
                
            }) {
                
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5.0)
                
            }
            
            EmptyView()
            
        }
        
        
    }
    
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
    
    
}






// Contains the game map and a switchable view for delivering messages and giving a countdown.
struct MainView: View {
    
    @State private var currentType: ViewType = .second

    
    let tower = CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059)
    
    // Default Region : For this it is based around the UWaterloo Campus
    // TODO: Update with UWATERLOO Campus Location
    @State var camera: MapCameraPosition = .automatic
    
    // Access to websocket connection

    
    var body: some View {
        
        VStack {
            
            // Our Title Screen
            HStack{
                currentType.view
                    .id(currentType) // Supposedly Forces the view Replacement
                    .transition(
                        // Custom animation to change the top View.
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        )
                    )
            }
            .animation(.default, value: currentType)
            .frame(maxWidth: .infinity, maxHeight: 50)
            
            Button {
                withAnimation {
                    let allCases = ViewType.allCases
                    if let currentIndex = allCases.firstIndex(of: currentType) {
                        
                        let nextType = allCases[(currentIndex + 1) % allCases.count]
                        
                        currentType = nextType
                    } else {
                        currentType = allCases[0];
                    }
                    
                }
                
                
            } label: {
                Text("Switch")
            }
            
            
            // Position is set by a Binding<MapCameraPosition>
            
            
            // Our Map
            Map(position: $camera) {
                //Marker("CN Tower", coordinate: tower)
                
                //Example Annotations
                Annotation("", coordinate: tower) {
                    Image(systemName: "circle.circle.fill")
                        .foregroundColor(Color.red)
                }
                
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: 40.7137, longitude: -74.0059)) {
                    Image (systemName: "circle.circle.fill")
                        .foregroundColor(Color.black)
                    
                }
                
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    Button {
                        // Center on CN Tower
                        camera = .region(MKCoordinateRegion(center: tower, latitudinalMeters: 200, longitudinalMeters: 200))
                        
                        
                        // Testing the emergency function
                        SendMessageToServer(text_in: "Test");
                    } label: {
                        Text("Reset")
                        
                    }
                    Spacer()
                    
                }
                .padding(.top)
                .padding(.bottom)
                .background(Color.black.opacity(0.2))
                
                
            }
            
        }
        .padding()
        
        
    }
    
    //
    func SendMessageToServer(text_in: String) {
         
    }
    
}

// View Structures for Switching Text Box.
// Header structure for switching views
enum ViewType: CaseIterable {
    case first
    case second
    case third
    case fourth
    
    @ViewBuilder var view: some View {
        switch self {
        case .first:
            FirstView()
        case .second:
            SecondView()
        case .third:
            ThirdView()
        case .fourth:
            EmergencyView()
        }
    }
    
    
}


// Text Instruction
struct FirstView: View {
    var body: some View {
        Text ("First Instruction")
            .padding()
            .font(.custom(
                fontSelection,
                fixedSize: 36
                
            ))
        
    }
    
    
}


// Title
struct SecondView: View {
    var body: some View {
        Text("⁂ Socratica Manhunt")
            .font(.custom(
                fontSelection,
                fixedSize: 36
                
            ))
        
    }
    
    
}





// Timer Display View
struct ThirdView: View {
    var body: some View {
        Text("This is the Time")
            .padding()
            .font(.custom(
                fontSelection,
                fixedSize: 36
                
            ))
    }
}

// An emergency message receieved from the server.
struct EmergencyView: View {
    var body: some View {
        Text(emergencyMessage)
            .padding()
            .font(.custom(
                fontSelection,
                fixedSize: 36
                
            ))
        
    }
    
}






#Preview {
    ContentView()
}
