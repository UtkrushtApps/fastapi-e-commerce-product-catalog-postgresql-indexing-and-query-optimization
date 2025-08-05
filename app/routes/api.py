from fastapi import APIRouter, Query
from typing import List, Optional
from app.database import get_connection
from app.schemas.schemas import Product

router = APIRouter(prefix="/api")

@router.get("/products", response_model=List[Product])
def list_products(category_id: Optional[int] = Query(None), brand_id: Optional[int] = Query(None)):
    conn = get_connection()
    cur = conn.cursor()
    # Inefficient: No WHERE clause index usage, always full scan and large join
    query = "SELECT p.id, p.name, p.price, p.category_id, p.brand_id FROM products p"
    conds = []
    params = []
    if category_id is not None:
        conds.append("p.category_id = %s")
        params.append(category_id)
    if brand_id is not None:
        conds.append("p.brand_id = %s")
        params.append(brand_id)
    if conds:
        query += " WHERE " + " AND ".join(conds)
    # No LIMIT, so loads everything
    cur.execute(query, tuple(params))
    rows = cur.fetchall()
    products = [Product(id=r[0], name=r[1], price=r[2], category_id=r[3], brand_id=r[4]) for r in rows]
    cur.close(); conn.close()
    return products
