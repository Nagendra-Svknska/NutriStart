import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from app.db import supabase

app = FastAPI(
    title="Food Delivery Project API",
    description="A simple FastAPI app for managing restaurants, orders, and deliveries.",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
class Order(BaseModel):
    id: int
    restaurant: str
    items: list[str]
    total: float
    status: str = "pending"

class LoginRequest(BaseModel):
    email: str
    password: str

@app.get("/")
def read_root():
    return {"message": "Welcome to the Food Delivery API, Yahoo!!!!"}

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/orders/{order_id}")
def read_order(order_id: int):
    return {
        "id": order_id,
        "restaurant": "Example Pizza",
        "items": ["Margherita", "Soft drink"],
        "total": 23.50,
        "status": "preparing",
    }

@app.post("/orders")
def create_order(order: Order):
    return {
        "message": "Order created successfully",
        "order": order,
    }

@app.post("/login")
def login(data: LoginRequest):

    print("MAIN FILE LOADED")

    if (
        data.email == "admin@test.com"
        and data.password == "123456"
    ):

        return {
            "access_token": "dummy_jwt_token",
            "token_type": "bearer"
        }

    return {
        "error": "Invalid credentials"
    }

@app.get("/menu")
def get_menu():

    print("get_menu endpoint called")
    response = supabase.table("Menu").select("*").execute()
    print(type(response.data))
    return response.data


# if __name__ == "__main__":
#     print("Starting the Food Delivery API...")
#     uvicorn.run("main:app", port=8000,reload=True )
#python main.py -- did not work


# uvicorn app.main:app --reload