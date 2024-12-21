<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Collaborative Code Editor</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.39.0/min/vs/loader.js"></script>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      transition: background-color 0.3s, color 0.3s;
      background-color: #1e1e1e;
      color: #ffffff;
      display: flex;
      flex-direction: column;
      height: 100vh;
      overflow: hidden;
    }

    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 30px 20px;
      background-color: #993366;
      color: white;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
      position: relative;
    }

    header h1 {
      font-size: 2rem;
      font-family: 'Bookman Old Style', serif;
      position: absolute;
      left: 50%;
      transform: translateX(-50%);
    }

    #theme-toggle {
      background-color: transparent;
      border: none;
      cursor: pointer;
      border-radius: 5px;
      transition: transform 0.3s;
      position: absolute;
      right: 20px;
    }

    #theme-toggle img {
      width: 25px;
      height: 25px;
      transition: transform 0.3s ease, filter 0.3s ease;
    }

    #editor-container {
      flex: 1;
      padding: 20px;
      background: linear-gradient(135deg, #2a2a2a, #1e1e1e);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }

    #editor {
      width: 100%;
      height: 90%;
      max-width: 1200px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
      border-radius: 10px;
      overflow: hidden;
    }

    #actions {
      margin-top: 10px;
      display: flex;
      gap: 10px;
    }

    button {
      padding: 10px 20px;
      font-size: 1rem;
      cursor: pointer;
      border: none;
      border-radius: 5px;
      background-color: #4CAF50;
      color: white;
      transition: background-color 0.3s ease;
    }

    button:hover {
      background-color: #45a049;
    }

    #output {
      margin-top: 10px;
      padding: 10px;
      background: #1e1e1e;
      color: white;
      border-radius: 5px;
      width: 100%;
      max-width: 1200px;
      font-family: monospace;
      overflow-wrap: break-word;
    }
  </style>
</head>
<body>
  <header>
    <h1>COLLABORATIVE CODE EDITOR</h1>
    <button id="theme-toggle">
      <img id="theme-icon" src="https://cdn-icons-png.flaticon.com/512/3936/3936598.png" alt="Light Theme Icon">
    </button>
  </header>

  <div id="editor-container">
    <div id="editor"></div>
    <div id="actions">
      <button id="save-code">Save Code</button>
      <button id="run-code">Run Code</button>
    </div>
    <div id="output">Output will appear here...</div>
  </div>

  <script>
    require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.39.0/min/vs' } });

    require(['vs/editor/editor.main'], function () {
      const editor = monaco.editor.create(document.getElementById('editor'), {
        value: "// Welcome to the Collaborative Java Code Editor!\n\npublic class HelloWorld {\n    public static void main(String[] args) {\n        System.out.println(\"Hello, World!\");\n    }\n}",
        language: 'java',
        theme: 'vs-dark'
      });

      const socket = new WebSocket("ws://localhost:8080");

      let isUpdating = false;

      socket.onopen = () => console.log("Connected to WebSocket server.");
      socket.onmessage = (event) => {
        const data = JSON.parse(event.data);
        if (data.change && !isUpdating) {
          applyTextChange(data.change);
        }
      };

      editor.getModel().onDidChangeContent((event) => {
        if (!isUpdating) {
          const change = event.changes[0];
          const message = JSON.stringify({ change: { range: change.range, text: change.text } });
          socket.send(message);
        }
      });

      function applyTextChange(change) {
        isUpdating = true;
        editor.getModel().applyEdits([{ range: change.range, text: change.text }]);
        isUpdating = false;
      }

      const saveButton = document.getElementById('save-code');
      saveButton.addEventListener('click', () => {
        const code = editor.getValue();
        const blob = new Blob([code], { type: 'text/plain' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'HelloWorld.java';
        link.click();
        URL.revokeObjectURL(link.href);
      });

      const runButton = document.getElementById('run-code');
      const outputDiv = document.getElementById('output');
      runButton.addEventListener('click', () => {
        const code = editor.getValue();

        socket.send(JSON.stringify({ code: code }));

        socket.onmessage = function (event) {
          const data = JSON.parse(event.data);
          if (data.output) {
            outputDiv.textContent = data.output;
          }
        };
      });

      const themeToggleBtn = document.getElementById('theme-toggle');
      const themeIcon = document.getElementById('theme-icon');
      let isDarkTheme = true;

      themeToggleBtn.addEventListener('click', () => {
        isDarkTheme = !isDarkTheme;
        monaco.editor.setTheme(isDarkTheme ? 'vs-dark' : 'vs-light');
        document.body.style.backgroundColor = isDarkTheme ? '#1e1e1e' : '#f5f5f5';
        document.body.style.color = isDarkTheme ? '#ffffff' : '#000000';
        themeIcon.src = isDarkTheme
          ? "https://cdn-icons-png.flaticon.com/512/3936/3936642.png"
          : "https://cdn-icons-png.flaticon.com/512/3936/3936598.png";
      });
    });
  </script>
</body>
</html>