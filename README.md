#RAConsoleEditor
![Screenshot](Resources/presentation.gif?raw=true)
Overview
-----------------
RAConsoleEditor is an Xcode plugin which makes it really easy to browse Xcode console logs in external text editors.

It often happens that during debugging session developer quickly ends up with the Xcode console full of text. Because of the (usually) small size of the console view and its limited functionality it is hard to effectively navigate within its content.

In many cases it is easier and faster to copy logs and paste them into the text document in order to view them in one’s [favourite text editor](http://stackoverflow.com/questions/20533/mac-text-code-editor). RAConsoleEditor does just  that - it speeds up the process of opening logs in external text editor by providing developer with couple of really handy shortcuts.

Installation
-----------------

###Manual installation
Simply download and build RAConsoleEditor Xcode plugin  and restart Xcode. The plugin will be automatically installed in 
*~/Library/Application Support/Developer/Shared/Xcode/Plug-ins*.

To remove the plugin remove *RAConsoleEditor.xcplugin* from the mentioned location.

###Alcatraz
RAConsoleEditor plugin is also available for download via [Alcatraz](http://alcatraz.io) package manager. Simply install Alcatraz plugin and use it to browse for the RAConsoleEditor plugin.

Features
-----------------
RAConsoleEditor adds three buttons to the bar visible at the bottom of the console view in Xcode. Functionality of  buttons depends on whether *Alt* button is pressed or not.

#### [Alt Not Pressed]
![Screenshot](Resources/bar-normal.png?raw=true)
- *Open* - Saves console logs to file and opens it in text editor of choice. By default created files are saved in temporary folder. User is asked for the application he/she wants to use when he/she wants to open file for the first time.
- *Save* - Saves console logs to file.
- *Explore* - Opens the directory in which saved files are stored.


#### [Alt Pressed]
![Screenshot](Resources/bar-alternate.png?raw=true)

- *Choose editor* - Allows the user to change application that is used to open saved console logs.
- *Save as* - Asks the user about the location on disc which next is next used to store file containing current console logs.
- *Choose default location* - Asks the user for the directory in which files are stored in case user isn’t explicitly asked for location of the file.

#### [Context Menu Without Pressed Alt]
![Screenshot](Resources/context-menu.png?raw=true)
- *Open* - Saves console logs to file and opens them in text editor of choice. By default created files are saved in temporary folder. User is asked for the application he/she wants to use when he/she wants to open file for the first time.
- *Save* - Saves console logs to file.
- *Explore* - Opens the directory in which saved files are stored.

#### [Context Menu With Pressed Alt]
![Screenshot](Resources/context-menu-alternate.png?raw=true)
- *Open* - Saves console logs to file and opens them in text editor of choice. By default created files are saved in temporary folder. User is asked for the application he/she wants to use when he/she wants to open file for the first time.
- *Save as* - Asks the user about the location on disc which next is next used to store file containing current console logs.
- *Explore* - Opens the directory in which saved files are stored.



Default file name format
-----------------

Both *Open* and *Save* actions require the plugin to create a file on a disc. In both of these cases name of the created file is generated automatically to make the action as fast as possible. Format of the name of the file follows pattern described below:

*Console Logs \(currentDate) \(currentTime)-\(twoRandomChars).txt*

- “*Console Logs*” - Prefix of the file name - self explanatory.
- *currentDate* - current date formatted using `NSDateFormatter` with `dateStyle` property set to `MediumStyle`.
- *currentTime* - current time formatted using `NSDateFormatter` with `timeStyle`property set to `MediumStyle`.
- *twoRandomChars* - two characters generated using [mkstemps](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/mkstemps.3.html) function. Their presence ensure uniqueness of the file name.


Author
-----------------

RAConsoleEditor was created by Rafał Augustyniak. You can find me on twitter ([@RaAugustyniak](https://twitter.com/RaAugustyniak)).

Licence
-----------------
		
	Copyright (c) 2016 Rafał Augustyniak

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.