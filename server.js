const SocketServer = require('websocket').server;
const http = require('http');

// * Create an HTTP server
const server = http.createServer((_req, _res) => {});

// * Initialize at port 3000
server.listen(3000, () => console.log('Listening for messages on port 3000'));

// * Create a WebSocket server
var wsServer = new SocketServer({ httpServer: server });

// * For tracking users connected to serve
const connections = [];
// * For storing messages
const messages = [];

// * When a request happens
wsServer.on('request', (req) => {
  // * Accept any incoming connections
  const connection = req.accept();
  console.log('new connection');
  // * store in array
  connections.push(connection);

  // * When a message is received
  connection.on('message', (mes) => {
    console.log(mes.utf8Data);
    // * store in messages array
    messages.push(mes.utf8Data);
    // * Send to every other connected user
    connections.forEach((client) => {
      client.send(JSON.stringify({ messages }));
    });
  });

  // * When a connection is closed
  connection.on('close', (_resCode, _des) => {
    console.log('connection closed');
    // * Remove that user from connections array
    connections.splice(connections.indexOf(connection), 1);
  });
});
