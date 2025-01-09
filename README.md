This app runs a manhunt game for a large group of people across a large area, by revealing the non-hunter players every 5 minutes during the duration of the game.

**System Flow Chart**

![Flow Chart of Manhunt App(https://github.com/PeterAlpajaro/Haptic_Feedback_Glove/blob/main/Images/FlowChart.jpg)

**Prototyping Image**

![Image of Prototype](https://github.com/PeterAlpajaro/Haptic_Feedback_Glove/blob/main/Images/HapticGlovePrototype.HEIC)

**Code Structure**

<ins>**HapticGloveIOS**<ins>
This is the code for the IOS app which processes the data to and from the glove. Current iteration takes the camera data from the IPhone camera, and then runs the DepthAnythingV2 Small model on the photo. It then takes a depth from four regions of the returned depth map, and writes those values over bluetooth to the glove.

**HapticGloveIOSApp.swift**
The swift file that runs the main and contains the class that manages environment variables over all classes of the app.

**ContentView.swift**
The swift file that manages the views used in the app including the view of the depth map, the grid, and the initial view to detect bluetooth devices.

**BluetoothManager.swift**
The swift file that manages all the connectivity for the bluetooth to and from the glove. Treats the glove as a peripheral and the phone as the central device.

**GridView.swift**
Written view that makes a 2x2 grid to display the active values for the selected regions in the depth map. Called in ContentView.swift.


**TODO<ins>HapticGloveFirmware<ins>**


