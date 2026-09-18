FROM node:22-alpine

WORKDIR /app

RUN cat <<'EOF' > server.js
const http = require('http');

const PORT = process.env.PORT || 8080;
const COLOR = process.env.APP_COLOR || 'blue';
const VERSION = process.env.APP_VERSION || '1.0.0';

http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        status: 'healthy',
        active_pool: COLOR,
        version: VERSION,
        timestamp: new Date().toISOString()
    }));
}).listen(PORT, () => {
    console.log(`Service [${COLOR} v${VERSION}] listening on port ${PORT}`);
});
EOF

USER node
EXPOSE 8080
CMD ["node", "server.js"]