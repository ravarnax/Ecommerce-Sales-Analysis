-- 1. Fill NULL categories so they show up as 'others' in your charts
UPDATE products 
SET product_category_name = 'others' 
WHERE product_category_name IS NULL;

-- 2. Standardize categories (Senior Tip: Some datasets have underscores or mixed cases)
-- This ensures 'cool_stuff' and 'Cool Stuff' are the same thing.
UPDATE products 
SET product_category_name = TRIM(LOWER(product_category_name));


