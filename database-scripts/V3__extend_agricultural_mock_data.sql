-- =========================================================================
-- DATABASE EXTENSION DATA: V3__extend_agricultural_mock_data.sql
-- TARGET DB: PostgreSQL 15+
-- DESCRIPTION: Extends machinery models and parts catalog for Lamborghini,
--              Kubota, and New Holland tractor configurations.
-- =========================================================================

-- 1. SEED ADDITIONAL MACHINERY MODELS
INSERT INTO machinery_models (brand, model_name, model_year, sku_prefix) VALUES
('Lamborghini', 'Spark 165', 2023, 'LAMB165'),
('Kubota', 'M7-173', 2022, 'KUBM173'),
('New Holland', 'T7.210', 2021, 'NHT7210')
ON CONFLICT (brand, model_name, model_year) DO NOTHING;

-- 2. SEED BRAND-SPECIFIC PARTS
-- Engine Components (Category ID: 1)
INSERT INTO parts (category_id, part_number, name, description, price, stock_quantity, image_url) VALUES
(1, 'KUB-1J411-32430', 'Kubota Fuel Filter Assembly', 'Genuine high-efficiency secondary diesel fuel filter element.', 42.10, 25, 'https://assets.agparts-mvp.local/images/parts/kub_fuel.jpg'),
(1, 'NH-84228488', 'New Holland Air Filter Element', 'Heavy-duty outer engine air filter engineered for high dust environments.', 89.50, 14, 'https://assets.agparts-mvp.local/images/parts/nh_air.jpg');

-- Hydraulic Systems (Category ID: 2)
INSERT INTO parts (category_id, part_number, name, description, price, stock_quantity, image_url) VALUES
(2, 'LAMB-0.015.4852.4', 'Lamborghini Hydraulic Control Valve', 'Premium multi-spool directional control valve assembly for precision lifting.', 310.00, 2, 'https://assets.agparts-mvp.local/images/parts/lamb_valve.jpg');


-- 3. SEED COMPATIBILITY MAPPINGS FOR NEW BRANDS
-- Note: Based on sequential auto-incrementing IDs, the new tractors will be IDs: 5, 6, and 7.
-- Kubota Fuel Filter fits Kubota M7-173 (Machinery ID: 6)
INSERT INTO part_compatibilities (part_id, machinery_id) VALUES 
((SELECT id FROM parts WHERE part_number = 'KUB-1J411-32430'), (SELECT id FROM machinery_models WHERE brand = 'Kubota' AND model_name = 'M7-173'));

-- New Holland Air Filter fits New Holland T7.210 (Machinery ID: 7)
INSERT INTO part_compatibilities (part_id, machinery_id) VALUES 
((SELECT id FROM parts WHERE part_number = 'NH-84228488'), (SELECT id FROM machinery_models WHERE brand = 'New Holland' AND model_name = 'T7.210'));

-- Lamborghini Hydraulic Valve fits Lamborghini Spark 165 (Machinery ID: 5)
INSERT INTO part_compatibilities (part_id, machinery_id) VALUES 
((SELECT id FROM parts WHERE part_number = 'LAMB-0.015.4852.4'), (SELECT id FROM machinery_models WHERE brand = 'Lamborghini' AND model_name = 'Spark 165'));

-- Universal Map Extension: Make the Quick-Disconnect Coupler Kit (Part ID 4 from V2) fit the new machines too!
INSERT INTO part_compatibilities (part_id, machinery_id) VALUES 
(4, (SELECT id FROM machinery_models WHERE brand = 'Lamborghini' AND model_name = 'Spark 165')),
(4, (SELECT id FROM machinery_models WHERE brand = 'Kubota' AND model_name = 'M7-173')),
(4, (SELECT id FROM machinery_models WHERE brand = 'New Holland' AND model_name = 'T7.210'))
ON CONFLICT (part_id, machinery_id) DO NOTHING;