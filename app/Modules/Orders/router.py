from fastapi import APIRouter, HTTPException, Header
from typing import Optional
from .Service import order_service
from .schema import OrderStatusUpdate, OrderRequest
from app.db import supabase
from app.env import Settings
from jose import jwt


router = APIRouter(prefix="/orders", tags=["Orders"])
print("Settings type: ",type(Settings))
settings = Settings()


@router.post("/")
def create_order(order: OrderRequest,authorization: str = Header(None)):
    user_email = get_current_user(authorization)
    # response = supabase.table("Orders").insert({
    #     "items": [item.dict() for item in order.items],
    #     "total": order.total,
    #     "status": "placed",
    #     "user_email": user_email,}).execute()
    response = order_service.create_order(order,user_email)


    return {"message": "Order placed successfully","data":response.data}    


@router.get("/admin/all")
async def get_admin_orders(authorization: str = Header(None)):
    require_admin(authorization)
    return order_service.get_admin_orders()


@router.put("/admin/{order_id}/status")
async def update_admin_order_status(
    order_id: str,
    payload: OrderStatusUpdate,
    authorization: str = Header(None),
):
    require_admin(authorization)
    return order_service.update_status(order_id, payload.status)


@router.get("/")
@router.get("/{order_id}")
async def get_orders(authorization: str = Header(None),order_id: Optional[str] = None,):
    try:
        print("enetered orders get endpoint")
        user_email = get_current_user(authorization)

        if order_id:
            print("order_id available : ",order_id)
            order = order_service.get_order_by_id(order_id,user_email)
            if not order:
                raise HTTPException(status_code=404,detail="Order not found")
            return {"success": True,"data": order}

        orders = order_service.get_all_orders(user_email)
        # print(orders)
        return orders
        # return {"success": True,"count": len(orders),"data": orders}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/{order_id}")
async def update_order_status(order_id: str,payload: OrderStatusUpdate,authorization: str = Header(None)):
    user_email = get_current_user(authorization)
    print("Updating order status for order ID: ", order_id)
    return order_service.update_status(order_id,payload.status)

def get_current_user(authorization: str = Header(None)):
    payload = get_current_payload(authorization)
    return payload["sub"]

def get_current_payload(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401,detail="Missing token")
    parts = authorization.split(" ")
    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise HTTPException(status_code=401, detail="Invalid token format")
    payload = jwt.decode(parts[1],settings.SECRET_KEY,algorithms=[settings.ALGORITHM])
    return payload

def require_admin(authorization: str = Header(None)):
    payload = get_current_payload(authorization)
    if payload.get("role") != "ADMIN":
        raise HTTPException(status_code=403, detail="Admin access required")
    return payload
