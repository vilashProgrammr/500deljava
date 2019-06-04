'use strict';

var http = require('http');

var server = http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(5000, '0.0.0.0');

console.log('server started123');
console.log("provess.env.invite="+process.env.invite);
console.log("provess.env.invite123="+process.env.invite123);
console.log("checkout the branch in"+process.env.invite123);

var signals = {
  'SIGINT': 2,
  'SIGTERM': 15
};

function shutdown(signal, value) {
  server.close(function () {
    console.log('server stopped by process some apis ' + signal);
	http.get('http://ec2-34-226-213-112.compute-1.amazonaws.com:3000/api/candidates/leaderboard', function(res){
    res.setEncoding('utf8');
    res.on('data', function(chunk){
	    console.log("http complete");
        console.log(chunk);
		process.exit(128 + value);
    });

});
 
  });
}

Object.keys(signals).forEach(function (signal) {
  process.on(signal, function () {
    shutdown(signal, signals[signal]);
  });
});
