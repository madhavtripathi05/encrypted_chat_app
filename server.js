// var WebSocket = require('ws');

// var port = process.env.PORT || 3000;

// var server = new WebSocket.Server({
//   port: port,
// });

// const connections = [];
// var messages = [{ id: 'server', msg: 'Welcome!' }];

// let msg = 'Server: Welcome!';

// server.on('connection', function connection(client) {
//   connections.push(client);
//   console.log(msg);
//   client.send(messages);
//   client.on('message', function incoming(message) {
//     messages.push(message);
//     connections.forEach((client) => {
//       client.sendUTF(messages.utf8Data);
//     });
//     // for (var cl of server.clients) {
//     //   cl.send({ 'msg-list': messages });
//     // }
//     console.log('Received the following message:\n' + message);
//   });
// });

const SocketServer = require('websocket').server;
const http = require('http');

const server = http.createServer((req, res) => {});

server.listen(3000, () => {
  console.log('Listening on port 3000...');
});

wsServer = new SocketServer({ httpServer: server });

const connections = [];
const messages = [];

wsServer.on('request', (req) => {
  const connection = req.accept();
  console.log('new connection');
  connections.push(connection);

  connection.on('message', (mes) => {
    console.log(mes.utf8Data);
    messages.push(mes.utf8Data);
    connections.forEach((element) => {
      element.send(JSON.stringify({ messages }));
    });
  });

  connection.on('close', (resCode, des) => {
    console.log('connection closed');
    connections.splice(connections.indexOf(connection), 1);
  });
});
