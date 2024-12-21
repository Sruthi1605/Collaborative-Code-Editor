const WebSocket = require('ws');
const { exec } = require('child_process');
const fs = require('fs');
const wss = new WebSocket.Server({ port: 8080 });

let clients = [];

wss.on('connection', (ws) => {
  console.log('New client connected!');
  clients.push(ws);

  // When a message is received from the client
  ws.on('message', (message) => {
    const data = JSON.parse(message);

    // Handle text changes in the code editor
    if (data.change) {
      console.log('Text change detected:', data.change);

      // Broadcast text change to all clients except the sender
      clients.forEach(client => {
        if (client !== ws) {
          client.send(JSON.stringify({ change: data.change }));
        }
      });
    }

    // Handle code execution requests
    if (data.code) {
      console.log('Received code to run:', data.code);

      const filename = 'HelloWorld.java';
      fs.writeFileSync(filename, data.code);

      // Compile Java code using full path to javac
      exec(`"C:\\Users\\HP\\Downloads\\WINDOWS.X64_213000_db_home\\jdk\\bin\\javac" ${filename}`, (compileErr, stdout, stderr) => {
        if (compileErr) {
          console.error('Compilation Error:', stderr);
          ws.send(JSON.stringify({ output: `Compilation Error: ${stderr}` }));
          return;
        }

        // Run the compiled Java program
        exec(`java -cp . HelloWorld`, (runErr, stdout, stderr) => {
          if (runErr) {
            console.error('Runtime Error:', stderr);
            ws.send(JSON.stringify({ output: `Runtime Error: ${stderr}` }));
          } else {
            console.log('Program Output:', stdout);
            ws.send(JSON.stringify({ output: stdout }));
          }
        });
      });
    }
  });
  // When the client disconnects
  ws.on('close', () => {
    clients = clients.filter(client => client !== ws);
    console.log('Client disconnected');
  });
});
