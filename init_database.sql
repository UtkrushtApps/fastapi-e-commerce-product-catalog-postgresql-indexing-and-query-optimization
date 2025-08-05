-- Inefficient schema and poor initial design
CREATE TABLE products (
    id SERIAL,
    name VARCHAR(255),
    price FLOAT,
    category_id INT,
    brand_id INT
    -- no primary key, no fk constraints, no indexes
);

CREATE TABLE categories (
    id SERIAL,
    name VARCHAR(255)
    -- no primary key
);

CREATE TABLE brands (
    id SERIAL,
    name VARCHAR(255)
    -- no primary key
);

INSERT INTO categories (name) VALUES ('Electronics'), ('Books'), ('Shoes'), ('Clothing');
INSERT INTO brands (name) VALUES ('BrandA'), ('BrandB'), ('BrandC'), ('BrandD');

-- Add products (simulate more for larger scans)
INSERT INTO products (name, price, category_id, brand_id) VALUES
('Smartphone', 299.99, 1, 1),
('Laptop', 799.99, 1, 2),
('Headphones', 59.95, 1, 3),
('Fiction Novel', 11.95, 2, 4),
('Running Shoes', 69.5, 3, 1),
('Dress Shirt', 29.99, 4, 2),
('Bluetooth Speaker', 39.99, 1, 1),
('Mystery Book', 12.99, 2, 2),
('Sneakers', 49.99, 3, 3),
('Polo Shirt', 22.50, 4, 4);

-- Add many more products to increase table size
DO $$
DECLARE
    i INT := 0;
BEGIN
    WHILE i < 200 LOOP
        INSERT INTO products (name, price, category_id, brand_id)
        VALUES (
            'Product' || i,
            (random() * 100 + 1),
            floor(random() * 4 + 1)::INT,
            floor(random() * 4 + 1)::INT
        );
        i := i + 1;
    END LOOP;
END$$;
