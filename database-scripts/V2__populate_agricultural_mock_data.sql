-- 1. SEED CATEGORIES (Skips if already exists)
INSERT INTO categories (name, slug, description) VALUES
('Engine Components', 'engine-components', 'Filters, belts, pistons, gaskets, and core internal internal combustion elements.'),
('Hydraulic Systems', 'hydraulic-systems', 'Pumps, cylinders, high-pressure hoses, valves, and fluid management units.'),
('Electrical & Ignition', 'electrical-ignition', 'Alternators, starters, heavy-duty batteries, wiring harnesses, and control relays.'),
('Transmission & Drivetrain', 'transmission-drivetrain', 'Clutch assemblies, universal joints, gears, drive shafts, and planetary gear assemblies.')
ON CONFLICT (name) DO NOTHING;

-- 2. SEED MACHINERY MODELS (Skips if already exists)
INSERT INTO machinery_models (brand, model_name, model_year, sku_prefix) VALUES
('John Deere', '5075E', 2018, 'JD5075'),
('John Deere', '6155M', 2021, 'JD6155'),
('Case IH', 'Puma 150', 2019, 'CIHP150'),
('Case IH', 'Magnum 340', 2022, 'CIHM340')
ON CONFLICT (brand, model_name, model_year) DO NOTHING;

-- 3. SEED PARTS (Skips if already exists)
INSERT INTO parts (category_id, part_number, name, description, price, stock_quantity, image_url) VALUES
(1, 'RE504836', 'Oil Filter Element', 'Premium high-efficiency engine oil filter designed for extreme agricultural environments.', 24.50, 45, 'https://assets.agparts-mvp.local/images/parts/re504836.jpg'),
(1, 'A-DZ111812', 'Heavy Duty V-Belt', 'Reinforced rubber drive belt engineered for high-torque alternator configurations.', 38.99, 12, 'https://assets.agparts-mvp.local/images/parts/adz111812.jpg'),
(2, 'HYD-PMP-150', 'Main Hydraulic Gear Pump', 'High-pressure displacement gear pump. Rated up to 210 bar operating threshold.', 489.00, 3, 'https://assets.agparts-mvp.local/images/parts/hyd-pmp-150.jpg'),
(2, 'HK-2204', 'Quick-Disconnect Coupler Kit', 'ISO 7241-A standard hydraulic quick coupler set with integrated dust caps.', 18.75, 120, 'https://assets.agparts-mvp.local/images/parts/hk-2204.jpg'),
(3, 'ALT-12V120A', '12V 120A Sealed Alternator', 'Dust-proof high-output alternator built to survive heavy field debris conditions.', 185.00, 8, 'https://assets.agparts-mvp.local/images/parts/alt-12v120a.jpg'),
(3, 'STR-MS350', 'Heavy Duty Starter Motor', 'High-torque direct-drive starter motor designed for cold-weather diesel ignition.', 215.50, 5, 'https://assets.agparts-mvp.local/images/parts/str-ms350.jpg'),
(4, 'CL-KIT-6000', 'Dual Stage Clutch Assembly', 'Heavy-duty 12-inch dual ceramic clutch kit with pressure plate and release alignment tool.', 675.00, 2, 'https://assets.agparts-mvp.local/images/parts/cl-kit-6000.jpg')
ON CONFLICT (part_number) DO NOTHING;

-- 4. SEED COMPATIBILITY MAPPINGS (Skips if already exists)
INSERT INTO part_compatibilities (part_id, machinery_id) VALUES 
(1, 1), (1, 2),
(2, 2), (2, 3),
(3, 3),
(4, 1), (4, 2), (4, 3), (4, 4),
(5, 2), (5, 3),
(6, 1),
(7, 3), (7, 4)
ON CONFLICT (part_id, machinery_id) DO NOTHING;