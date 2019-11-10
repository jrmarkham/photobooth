PHOTO BOOTH 
Project Structure 
For keeping state and managing data and UI. I like to use a BLoC pattern.  
BLoC pattern is similar to Redux but much easier (at least for me) to get running. 

BLoCs have 3 parts each is it a file name accordingly, in bold. Common usage is to put them in a directory: my 
	
Core Bloc — where the processing logic is done. my_bloc.dart
An Event Bloc that defines what comes into the bloc. Events may have parameters. my_event.dart
State Bloc that defines what comes out of the BLoC after processing. Like events, states may have parameters. my_state.dart
A fourth file is generated for exporting BLoC elements together. bloc.dart

It uses common terminology. Events and States. For each BLoC, you set up events to send to the BLoC. These events may be trigger by either UI interaction or from the BLoC while process other events and states. The BLoC state is passed back in response to processing the events. These state changes may be handled by listeners, streams or builders. Builders may be set up as a stream so I just use builders. To use these BLoCs throughout the app you declare and initialize them in the main function of the app. You do this through a BLoC provider (or a Multi-BLoC provider). Then in the first UI class (called app), I set up all my listeners. You may but them anywhere or everywhere you have UI, but I like keeping them all together so the logic for the listeners is all in one place. In general, the listeners are for directing the BLoCs to each other. For example, a UI update returns state that may trigger a data change in another BLoC and of course, data may respond with state and that state may update UI with the appropriate event. I also like to global call all alerts and modals from here. Any non-route page changes.  

The Builder is for Rendering UI. When data changes and reflects that in the state a builder will rebuild the UI with an updated state. This works very similar to a stream builder which is triggered by updates. There is no reason to use both, so I use builders and set up streams inside the BLoCs themselves.

The BLoC Magic happens inside the actual BLoCs. Data and services set up in the BLoCs to manages all the data much like a controller in MVC. Services may be set up for pretty much anything here. Services my be Database connection or more complex code process data in the BLoC.

So the architecture is dived up by data and UI. The BLoC are in data and they also govern services(MVS) and processing (MVC). The UI is split into pages (for most projects) but in this one there was no routing necessary. If the app was fully realized there would be an archive page for save photo both documents.

Global Data: I like to create a global file for non-secure items and constants that will be used throughout the app. Global Data includes content text, enums, styles, media and the like.

Drawing Challenges 
This was fun. The mechanism of recording pencil strokes is designed to draw at the end of the stroke. The data update post on the end of UI Event of end of Pan which means the display draws after the stroke has been made. To improve the UX an additional display was made for (as a user traces). With further development, these display mechanisms could be combined.

Data Challenges
I would have handled things a little differently if this was my project. The save photo works from the widget that frames the photo and the pencil marks and converts the stack to bytes and posts the png file accordingly. The Photo Booth Document saves the original photo as a png and all the drawing data as a JSON file. 

Restore is implemented with "Saved Preferences"; in a real app the restore would run off of the saved files and I would build an archives list. The reload works complete on real devices and android emulators, but on Xcode simulators, the simulator doesn’t recognize the path of the image file. This is a limitation of the simulator, not the code, but in a real project, I’d probably universally save image data on the server and reload it from there accordingly.

Here are the links to the saved data: 

https://sandbox.markhamenterprises.com/docs/pbd/
https://sandbox.markhamenterprises.com/photos/images/ 

Testing -- I created core tests for BLoC and services. You may run them at the command line:> Flutter test