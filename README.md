# Collaborative Code Editor

## Overview
The **Collaborative Code Editor** is a real-time application that enables multiple users to collaboratively edit Java code. This tool is designed for coding sessions, team collaboration, and programming exercises, offering features like live updates, theme switching, and code execution.  

## Features
- **Real-Time Collaboration:** Synchronize code changes among multiple users in real-time using WebSocket.
- **Integrated Monaco Editor:** Provides a powerful and customizable code editing interface.
- **Theme Toggle:** Switch between light and dark themes for a personalized experience.
- **Code Execution:** Compile and execute Java code directly within the application.
- **Save Code Locally:** Save your code to a file with a single click.

## Technologies Used
- **Frontend:** HTML, CSS, JavaScript, Monaco Editor.
- **Backend:** Node.js, Java, JSP, WebSocket.
- **Additional Tools:** fs and child_process modules in Node.js for handling files and executing Java code.

## How It Works
1. The **Monaco Editor** is embedded in the frontend to provide a rich coding experience.
2. WebSocket is used for real-time communication between the clients and the server.
3. Users can write Java code in the editor, save it locally, or execute it directly using the backend server.
4. The backend compiles and runs the Java code and returns the output to the client.

## Installation and Setup
1. Clone the repository:  
   ```bash
   git clone https://github.com/<your-username>/collaborative-code-editor.git
2. Navigate to the project directory:
cd collaborative-code-editor

3. Install dependencies for the server:
npm install
4. Run the server:
node server.js

## Usage
Open the application in multiple browser tabs or devices.
Collaborate on Java code in real time.
Toggle between light and dark themes using the theme button.
Save code locally or execute it to view the output.

## Screenshots
Add relevant screenshots of the application here.
### Outline  
![Outline](screenshots/editor-interface.png)
