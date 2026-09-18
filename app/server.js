const http = require('http');

const PORT = process.env.PORT || 8080;
const VERSION = process.env.APP_VERSION || '1.0.0';
const COLOR = process.env.APP_COLOR || 'blue';

const server = http.createServer((req, res) => {
    if (req.url === '/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({ status: 'healthy', version: VERSION, color: COLOR }));
    }

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        message: 'Request served with zero downtime',
        version: VERSION,
        color: COLOR,
        timestamp: new Date().toISOString()
    }));
});

server.listen(PORT, () => {
    console.log(`Server running on port ${PORT} [Version: ${VERSION}, Color: ${COLOR}]`);
});