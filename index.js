const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 3000;

// Basic reverse proxy setup
app.use('/proxy', createProxyMiddleware({
    target: 'http://example.com', // Target server
    changeOrigin: true,
}));

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
