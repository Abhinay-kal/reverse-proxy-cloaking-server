import http.server
import socketserver

# Define the port on which the server will run
PORT = 8080  # You can change this if needed

# Set up a simple HTTP request handler
Handler = http.server.SimpleHTTPRequestHandler

# Create a TCP server instance
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving HTTP on port {PORT}... Press Ctrl+C to stop.")
    httpd.serve_forever()