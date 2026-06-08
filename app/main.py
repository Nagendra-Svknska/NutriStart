import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from app.db import supabase
from app.env import Settings
from typing import List
from jose import jwt
from datetime import datetime, timedelta
from fastapi import  HTTPException,Header
from app.Modules.Orders.router import router as order_router


print("Starting the Food Delivery API...")
settings = Settings()


app = FastAPI(
    title="Food Delivery Project API",
    description="A simple FastAPI app for managing restaurants, orders, and deliveries.",
    version="0.1.0",
)

app.include_router(order_router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class LoginRequest(BaseModel):
    email: str
    password: str

# class OrderItem(BaseModel):
#     name: str
#     quantity: int
#     price: float

# class OrderRequest(BaseModel):
#     items: List[OrderItem]
#     total: float




@app.get("/")
def read_root():
    return {"message": "Welcome to the Food Delivery API, Yahoo!!!!"}

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.post("/login")
def login(data: LoginRequest):

    try:
        print("NEW MAIN FILE LOADED")
        user = (supabase.table("users").select("*").eq("email", data.email).single().execute())
        if (data.password == user.data["password"]):
            print("Valid user with role :",user.data["role"])
            role = user.data["role"]
            token = create_access_token({"sub": data.email, "role": role})
            return {"access_token": token,"token_type": "bearer","role": role}
        else :
            print("Invalid user : not found in database or password mismatch")

        return {"error": "Invalid credentials"}

    except Exception:
        return {"error": "User not found"}



@app.get("/menu")
def get_menu():

    print("get_menu endpoint called")
    response = supabase.table("Menu").select("*").execute()
    print(type(response.data))
    return response.data

# @app.post("/orders")
# def create_order(order: OrderRequest,authorization: str = Header(None)):
#     user_email = get_current_user(authorization)
#     response = supabase.table("Orders").insert({
#         "items":
#         [
#             item.dict()
#             for item in order.items
#         ],
#         "total": order.total,
#         "status": "placed",
#         "user_email": user_email,}).execute()

#     return {"message": "Order placed successfully","data":response.data}

# @app.get("/orders")
# def get_orders(authorization: str = Header(None)):
#     user_email = get_current_user(authorization)
#     response = supabase.table("Orders").select("*").eq("user_email",user_email).execute()
#     return response.data


def create_access_token(data: dict):

    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode,settings.SECRET_KEY,algorithm=settings.ALGORITHM)
    return encoded_jwt

# def get_current_user(authorization: str = Header(None)):

#     if not authorization:
#         raise HTTPException(status_code=401,detail="Missing token")
#     token =authorization.split(" ")[1]
#     payload = jwt.decode(token,settings.SECRET_KEY,algorithms=[settings.ALGORITHM])
#     return payload["sub"]



# if __name__ == "__main__":
#     print("Starting the Food Delivery API...")
#     uvicorn.run("main:app", port=8000,reload=True )
#python main.py -- did not work


# uvicorn app.main:app --reload




# @app.post("/orders")
# def create_order(order: OrderRequest):

#     response = supabase.table("Orders").insert({
#         "items": 
#         [
#             item.dict()
#             for item in order.items
#         ],
#         "total": order.total,
#         "status": "placed",}).execute()

#     return {"message":"Order placed successfully","data":response.data}
