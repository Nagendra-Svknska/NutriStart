from jose import jwt
from datetime import datetime, timedelta
from app.env import Settings
from fastapi import Header, HTTPException

settings = Settings()

class auth_core:

    def create_access_token(data: dict):

        to_encode = data.copy()
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        to_encode.update({"exp": expire})
        encoded_jwt = jwt.encode(to_encode,settings.SECRET_KEY,algorithm=settings.ALGORITHM)
        return encoded_jwt

    def get_current_user(authorization: str = Header(None)):

        if not authorization:
            raise HTTPException(status_code=401,detail="Missing token")
        token =authorization.split(" ")[1]
        payload = jwt.decode(token,settings.SECRET_KEY,algorithms=[settings.ALGORITHM])
        return payload["sub"]