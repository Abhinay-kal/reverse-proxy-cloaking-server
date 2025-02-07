#!/bin/bash

echo "🚀 Setting up Reverse Proxy Cloaking Server..."

# Step 1: Install Node.js and npm (Linux-based systems)
if ! command -v node &> /dev/null
then
    echo "🔧 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "✅ Node.js is already installed!"
fi

# Step 2: Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "🔧 Installing Git..."
    sudo apt-get install -y git
else
    echo "✅ Git is already installed!"
fi

# Step 3: Clone GitHub Repository
echo "📂 Cloning the repository..."
git clone https://github.com/YOUR_GITHUB_USERNAME/reverse-proxy-cloaking-server.git
cd reverse-proxy-cloaking-server || exit

# Step 4: Initialize Node.js project
echo "📦 Initializing npm..."
npm init -y

# Step 5: Install required dependencies
echo "📦 Installing dependencies..."
npm install express http-proxy-middleware axios greenlock-express openai dotenv

# Step 6: Create a `.env` file for storing API keys
echo "🔑 Creating environment variables..."
cat <<EOT > .env
OPENAI_API_KEY=your-openai-api-key
PORT=3000
SPECIAL_TOKEN=your-secret-token
EOT

# Step 7: Create the server file
echo "📝 Creating server file..."
cat <<EOT > index.js
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const { Configuration, OpenAIApi } = require('openai');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// AI Configuration
const configuration = new Configuration({
    apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

async function generateContent(prompt) {
    const response = await openai.createCompletion({
        model: 'text-davinci-003',
        prompt: prompt,
        max_tokens: 100,
    });
    return response.data.choices[0].text;
}

// Middleware for token-based access control
app.use((req, res, next) => {
    const token = req.headers['x-special-token'];
    req.isSpecial = token === process.env.SPECIAL_TOKEN;
    next();
});

// Reverse proxy route
app.use('/proxy', createProxyMiddleware({
    target: 'http://example.com',
    changeOrigin: true,
}));

// Dynamic content based on user type
app.get('/', (req, res) => {
    if (req.isSpecial) {
        res.send('🚀 Special Access: Welcome to the secret area!');
    } else {
        res.send('📜 Regular Blog Content');
    }
});

// AI-powered content generation
app.get('/ai-content', async (req, res) => {
    const content = await generateContent("Generate a blog post about reverse proxies.");
    res.send(content);
});

app.listen(PORT, () => {
    console.log(\`🚀 Server running on port \${PORT}\`);
});
EOT

# Step 8: Run the server
echo "🚀 Starting the server..."
node index.js
