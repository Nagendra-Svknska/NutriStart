# Food Delivery Project

A minimal FastAPI application for a food delivery service.

## Run locally

1. Create a virtual environment:
   ```bash
   python -m venv .venv
   .venv\Scripts\activate
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Start the app:
   ```bash
   uvicorn app.main:app --reload
   ```

## Endpoints

- `GET /` - welcome message
- `GET /health` - health check
- `GET /orders/{order_id}` - sample order details
- `POST /orders` - create an order
