-- ILYA | إيليا - Production E-Commerce Database Schema (PostgreSQL / SQLite Compatible)

CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(64) PRIMARY KEY,
    slug VARCHAR(128) UNIQUE NOT NULL,
    name_ar VARCHAR(255) NOT NULL,
    name_tr VARCHAR(255) NOT NULL,
    description_ar TEXT,
    description_tr TEXT,
    image_url TEXT,
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(64) PRIMARY KEY,
    sku VARCHAR(64) UNIQUE NOT NULL,
    slug VARCHAR(191) UNIQUE NOT NULL,
    category_id VARCHAR(64) NOT NULL,
    name_ar VARCHAR(255) NOT NULL,
    name_tr VARCHAR(255) NOT NULL,
    description_ar TEXT NOT NULL,
    description_tr TEXT NOT NULL,
    fabric_care_ar TEXT,
    fabric_care_tr TEXT,
    price DECIMAL(10, 2) NOT NULL,
    old_price DECIMAL(10, 2),
    currency VARCHAR(8) DEFAULT 'TRY',
    stock INT NOT NULL DEFAULT 0,
    sizes_json TEXT NOT NULL,   -- JSON array e.g. ["XS","S","M","L","XL"]
    colors_json TEXT NOT NULL,  -- JSON array of {code, name_ar, name_tr, hex}
    images_json TEXT NOT NULL,  -- JSON array of image URLs / angles
    is_new BOOLEAN DEFAULT FALSE,
    is_bestseller BOOLEAN DEFAULT FALSE,
    is_featured BOOLEAN DEFAULT FALSE,
    is_sample BOOLEAN DEFAULT FALSE,
    sales_count INT DEFAULT 0,
    seo_title_ar VARCHAR(255),
    seo_title_tr VARCHAR(255),
    seo_desc_ar TEXT,
    seo_desc_tr TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(64) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(32),
    role VARCHAR(20) DEFAULT 'customer', -- 'customer' | 'admin'
    preferred_lang VARCHAR(5) DEFAULT 'ar',
    kvkk_consent BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_addresses (
    id VARCHAR(64) PRIMARY KEY,
    user_id VARCHAR(64) NOT NULL,
    title VARCHAR(100) NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    phone VARCHAR(32) NOT NULL,
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    address_line TEXT NOT NULL,
    postal_code VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS wishlist (
    id VARCHAR(64) PRIMARY KEY,
    user_id VARCHAR(64),
    guest_session_id VARCHAR(128),
    product_id VARCHAR(64) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS price_alerts (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) NOT NULL,
    user_id VARCHAR(64),
    email VARCHAR(255) NOT NULL,
    lang VARCHAR(5) DEFAULT 'ar',
    baseline_price DECIMAL(10, 2) NOT NULL,
    target_price DECIMAL(10, 2),
    channel_email BOOLEAN DEFAULT TRUE,
    channel_push BOOLEAN DEFAULT FALSE,
    push_subscription_json TEXT,
    status VARCHAR(32) DEFAULT 'active', -- 'active' | 'notified' | 'cancelled'
    notified_at TIMESTAMP,
    last_notified_price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS coupons (
    id VARCHAR(64) PRIMARY KEY,
    code VARCHAR(64) UNIQUE NOT NULL,
    discount_type VARCHAR(20) NOT NULL, -- 'percent' | 'fixed'
    discount_value DECIMAL(10, 2) NOT NULL,
    min_order_amount DECIMAL(10, 2) DEFAULT 0,
    usage_limit INT DEFAULT 1000,
    used_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(64) PRIMARY KEY,
    order_number VARCHAR(32) UNIQUE NOT NULL,
    user_id VARCHAR(64),
    customer_first_name VARCHAR(100) NOT NULL,
    customer_last_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(32) NOT NULL,
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    address_line TEXT NOT NULL,
    shipping_method VARCHAR(64) NOT NULL,
    shipping_cost DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(64) NOT NULL, -- 'iyzico' | 'paytr' | 'cod' | 'bank_transfer'
    payment_status VARCHAR(32) DEFAULT 'pending_gateway',
    payment_gateway_ref VARCHAR(128),
    subtotal DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    coupon_code VARCHAR(64),
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(32) DEFAULT 'processing', -- 'processing' | 'shipped' | 'delivered' | 'cancelled'
    items_json TEXT NOT NULL,
    kvkk_accepted BOOLEAN DEFAULT TRUE,
    distance_sales_accepted BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS site_settings (
    setting_key VARCHAR(100) PRIMARY KEY,
    value_ar TEXT,
    value_tr TEXT,
    config_json TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
