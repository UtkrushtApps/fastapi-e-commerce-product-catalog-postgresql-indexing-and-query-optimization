# Task Overview
This task centers around an e-commerce product catalog managed by a FastAPI backend. End users report sluggish performance—product listing endpoints take over 3 seconds to return results when filtering by both category and brand. After analysis, the issue is traced back to the PostgreSQL database: the schema for products, categories, and brands is denormalized, missing key constraints, and lacks strategic indexes. You are to optimize the schema and queries so product listings and filters are consistently fast, directly supporting core business operations.

# Guidance
- Sequential scans are occurring when filtering products by category and brand due to missing composite indexes.
- The current schema is missing primary/foreign key constraints and uses less efficient data types (e.g., VARCHAR(255) where shorter types suffice).
- There are no indexes on the filter columns commonly accessed by API endpoints.
- Existing queries retrieve too much data and do not leverage SQL query best practices (no LIMIT, inefficient WHERE).
- Your focus is:
  - Analyzing query execution with EXPLAIN ANALYZE
  - Designing and implementing composite B-tree indexes
  - Adding primary and foreign keys between products, categories, and brands
  - Checking the effect of optimizations using database client tools
- Do not modify the FastAPI application layer or routing logic—optimize only schema and database integration logic.

# Database Access
- Host: <DROPLET_IP>
- Port: 5432
- Database: ecommerce
- Username: ecommerce
- Password: ecommercepwd
- Any PostgreSQL client (pgAdmin, DBeaver, psql) can be used for investigation, EXPLAIN, and monitoring

# Objectives
- Analyze and identify the slow product listing queries, noting where sequential scans or inefficient joins occur.
- Implement a composite B-tree index on (category_id, brand_id) in the products table.
- Add proper primary and foreign key constraints to establish normalized relationships.
- Optimize product listing queries to reliably execute in under 250 milliseconds for typical filter operations.
- Retain all application logic and API contract—confirm correctness via the API.

# How to Verify
- Use EXPLAIN ANALYZE to compare query execution plans before and after your changes—sequential scans should become index scans.
- Confirm improved API response times for /products endpoints with category & brand filters using curl or Postman.
- Validate constraints and relationships in the database (foreign key integrity, no orphaned records).
- Optional: Use pg_stat_statements to observe reduced average latency for product listing queries.