-- =========================================================================
-- DATABASE INITIALIZATION SCHEMA: V1__init_agricultural_store_schema.sql
-- TARGET DB: PostgreSQL 15+
-- DESCRIPTION: Sets up core e-commerce relational structure for agricultural parts MVP.
-- =========================================================================

-- 1. CATEGORIES TABLE (Hierarchical structure for part classifications)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE, -- URL friendly name (e.g., 'engine-components')
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. MACHINERY MODELS TABLE (Tracking tractor/machine types and brands)
CREATE TABLE machinery_models (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(100) NOT NULL,       -- e.g., 'John Deere', 'Case IH', 'New Holland'
    model_name VARCHAR(100) NOT NULL,  -- e.g., '5075E', 'Puma 150'
    model_year INT,                    -- Production starting/specific year
    sku_prefix VARCHAR(10),            -- Optional shorthand for manufacturing tracking
    UNIQUE (brand, model_name, model_year) -- Prevents duplicate tractor configurations
);

-- 3. PARTS TABLE (Core inventory data)
CREATE TABLE parts (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    part_number VARCHAR(50) NOT NULL UNIQUE, -- OEM or Custom SKU (e.g., 'AZ-451/B')
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0.00), -- Enforces positive pricing
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0), -- Prevent negative stock
    image_url VARCHAR(512),            -- Path to optimized cloud asset bucket (S3/Cloudinary)
    is_active BOOLEAN DEFAULT TRUE,    -- Soft delete / draft mechanic for Admin control
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_part_category FOREIGN KEY (category_id) 
        REFERENCES categories(id) ON DELETE RESTRICT
        -- ON DELETE RESTRICT prevents deleting a category if it still has parts inside it!
);

-- 4. PART COMPATIBILITY JUNCTION TABLE (Handles the Many-to-Many Relationship)
CREATE TABLE part_compatibilities (
    part_id INT NOT NULL,
    machinery_id INT NOT NULL,
    PRIMARY KEY (part_id, machinery_id), -- Enforces that a link can only be mapped once
    
    CONSTRAINT fk_compatibility_part FOREIGN KEY (part_id) 
        REFERENCES parts(id) ON DELETE CASCADE,
        -- ON DELETE CASCADE ensures if a part is deleted, its compatibility links are wiped too.
        
    CONSTRAINT fk_compatibility_machinery FOREIGN KEY (machinery_id) 
        REFERENCES machinery_models(id) ON DELETE CASCADE
);

-- =========================================================================
-- INDEXES FOR HIGH-PERFORMANCE SEARCH QUERYING
-- =========================================================================
-- Farmers search by part numbers and categories constantly; indexes keep lookups near-instantaneous.
CREATE INDEX idx_parts_part_number ON parts(part_number);
CREATE INDEX idx_machinery_brand_model ON machinery_models(brand, model_name);