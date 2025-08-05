from pydantic import BaseModel
from typing import Optional

class Product(BaseModel):
    id: int
    name: str
    price: float
    category_id: int
    brand_id: int
