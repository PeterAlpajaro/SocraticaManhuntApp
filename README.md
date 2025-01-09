This app runs a manhunt game for a large group of people across a large area, by revealing the non-hunter players every 5 minutes during the duration of the game. Server code is in the SocraticaManhuntServer repository

**System Flow Chart**

![Flow Chart of Manhunt App](https://github.com/PeterAlpajaro/SocraticaManhuntApp/blob/main/Images/Diagram.jpeg)

**<ins>Code Structure<ins>**

**Socratia_ManhuntApp**
Initializes the app and its views. Also contains login status environment variable.

**ContentView.swift**
Contains both the login and main view structures. The main view displays the map with all player locations on the active game area.

**Authentication.swift**
Manages the initial login request to the server along with the WebSocket establishment and handles requests coming in from the server for location.



