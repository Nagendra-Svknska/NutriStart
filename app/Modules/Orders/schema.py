from enum import Enum
from pydantic import BaseModel
from typing import List



class OrderItem(BaseModel):
    name: str
    quantity: int
    price: float

class OrderRequest(BaseModel):
    items: List[OrderItem]
    total: float

class OrderStatus(str, Enum):
    PLACED = "placed"
    PENDING = "PENDING"
    ACCEPTED = "ACCEPTED"
    REJECTED = "REJECTED"
    PREPARING = "PREPARING"
    READY = "READY"
    OUT_FOR_DELIVERY = "OUT_FOR_DELIVERY"
    DELIVERED = "DELIVERED"
    CANCELLED = "CANCELLED"

class OrderStatusUpdate(BaseModel):
    status: OrderStatus
