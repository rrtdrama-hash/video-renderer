# Render deployment

Create a **Web Service** in Render from this repository and select **Docker** as the runtime. Render will build the included `Dockerfile` and provide the `PORT` environment variable automatically.

Recommended settings:

- Health check path: `/health`
- Start command: leave blank; the Dockerfile starts the service
- Environment variable: `PUBLIC_BASE_URL=https://your-service-name.onrender.com` (optional; `RENDER_EXTERNAL_URL` is used automatically when this is omitted)

The service listens on `0.0.0.0` and supports Render's forwarded HTTPS requests. Uploaded files and generated videos use the service's local disk, so they are temporary and can be lost when the service restarts or redeploys. Use a persistent disk or object storage if videos must survive restarts.
