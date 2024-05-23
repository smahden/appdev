CREATE DATABASE cde1101_project;

USE cde1101_project;

CREATE TABLE users (
    USERID INT AUTO_INCREMENT PRIMARY KEY,
    USERNAME VARCHAR(50) NOT NULL UNIQUE,
    PASSWORD VARCHAR(255) NOT NULL,
    NAME VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    PRODUCTID INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    DESCRIPTION TEXT,
    PRICE DECIMAL(10, 2) NOT NULL,
    IMAGE VARCHAR(255)
);

CREATE TABLE sales (
    SALESID INT AUTO_INCREMENT PRIMARY KEY,
    USERID INT,
    PRODUCTID INT,
    QUANTITY INT NOT NULL,
    SIZE ENUM('S', 'M', 'L') NOT NULL,
    SUGAR_LEVEL ENUM('25%', '50%', '75%', '100%') NOT NULL,
    ICE_LEVEL ENUM('No Ice', 'Less Ice', 'Normal') NOT NULL,
    ADD_ONS TEXT,
    TOTAL_AMOUNT DECIMAL(10, 2) NOT NULL,
    DATE_OF_PURCHASE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (USERID) REFERENCES users(USERID),
    FOREIGN KEY (PRODUCTID) REFERENCES products(PRODUCTID)
);

insert into users values (1, "mah", "1234", "mahden")
insert into products values  (3, "chocolate", "a very creamy australian chocolate", 100.00, "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2011/4/5/2/RX-FNM_050111-TV-Sweeps-017_s4x3.jpg.rend.hgtvcom.1280.1280.suffix/1371597326911.jpeg"),
(4, "Cheese Cake", "creamy cheese cake with premium milk tea", 150.00, "https://milkteasupplier.ph/wp-content/uploads/2020/03/inJoy-Mango-Cheesecale-Milk-Tea-Drinks.png")
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image VARCHAR(255)
);

CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT,
    addons VARCHAR(255),
    sugar_level VARCHAR(50),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);


