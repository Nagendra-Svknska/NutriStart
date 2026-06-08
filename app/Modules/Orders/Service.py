from app.Modules.Orders.schema import OrderRequest
from app.db import supabase

class OrderService:

    def create_order(self,order:OrderRequest,user_email:str):

        response = supabase.table("Orders").insert({
            "items": [item.dict() for item in order.items],
            "total": order.total,
            "status": "placed",
            "user_email": user_email,}).execute()
        return response
    

    def get_all_orders(self, user_email: str):
        print("Fetching orders 'get_all_orders' for user: ", user_email)
        response = (
            supabase.table("Orders")
            .select("*")
            .order("created_at", desc=True)
            .eq("user_email", user_email)
            .execute()
        )

        return response.data

    def get_admin_orders(self):

        response = (
            supabase.table("Orders")
            .select("*")
            .order("created_at", desc=True)
            .execute()
        )

        return response.data

    def get_order_by_id(self, order_id: str, user_email: str):

        response = (
            supabase.table("Orders")
            .select("*")
            .eq("id", order_id)
            .eq("user_email", user_email)
            .single()
            .execute()
        )

        return response.data
    

    def update_status(self, order_id, status):

        response = (
            supabase
            .table("Orders")
            .update(
                {
                    "status": status
                }
            )
            .eq("id", order_id)
            .execute()
        )

        return response.data

order_service = OrderService()

    
