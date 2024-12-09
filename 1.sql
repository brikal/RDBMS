use db1;
create table client_master(
	client_no varchar(6) primary key check(client_no like '%c' and length(client_no)=6),
    Name varchar(20) not null,
    address1 varchar(30),
    address2 varchar(30), 
    city varchar(15),
    pincode int(8),
    state varchar(15),
    bal_due decimal(10,2)
    #constraint chk_client_no check(client_no like '%c' and length(client_no)=6)
);

insert into client_master (client_no, Name, city, pincode, state, bal_due) values
('C00001', 'Ivan Bayross', 'Bombay', 400054, 'Maharashtra', 15000),
('C00002', 'Vandana Saitwal', 'Madras', 780001, 'Tamil Nadu', 0),
('C00003', 'Pramada Jaguste', 'Bombay', 400057, 'Maharashtra', 5000),
('C00004', 'Basu Navindgi', 'Bombay', 400056, 'Maharashtra', 0),
('C00005', 'Ravi Sreedharan', 'Delhi', 100001, 'Delhi', 2000),
('C00006', 'Rukmini', 'Bombay', 400050, 'Maharashtra', 0);

select * from client_master;

create table product_master(
	Product_no varchar(6) primary key check(product_no like '%c' and length(product_no)=6),
    Description varchar(15) not null,
    Profit_percent float(4,2) not null,
    Unit_measure varchar(10) not null,
    Oty_on_hand int(8) not null,
    Reorder_lvl int(8) not null,
    Sell_price decimal(8,2) not null check(sell_price != 0),
    Cost_price decimal(8,2) not null check(cost_price != 0)
    #constraint chk_product_no check(product_no like '%c' and length(product_no)=6)
);

insert into product_master (Product_no, Description, Profit_percent, Unit_measure, Oty_on_hand, Reorder_lvl, Sell_price, Cost_price) values
('P00001', '1.44 Floppies', 5, 'Piece', 100, 20, 525, 500),
('P03453', 'moniters', 6, 'Piece', 10, 3, 12000, 11280),
('P06734', 'mouse', 5, 'Piece', 100, 20, 525, 500),
('P07865', '1.22 Floppies', 5, 'Piece', 100, 20, 525, 500),
('P07868', 'keyboards', 2, 'Piece', 10, 3, 3150, 3050),
('P07885', 'CD Drive', 2.5, 'Piece', 10, 3, 5250, 5100),
('P07965', '540 HHD', 4, 'Piece', 10, 3, 8400, 8000),
('P07975', '1.44 Drive', 5, 'Piece', 10, 3, 1050, 1000),
('P08865', '1.22 Drive', 5, 'Piece', 2, 3, 1050, 1000);

select * from product_master;

create table salesman_master(
	salesman_no varchar(6) primary key check(salesman_no like '%c'),
    Salesman_name varchar(20) not null,
    Address1 varchar(30) not null,
    Address2 varchar(30),
    City varchar(20),
    Pincode varchar(8),
    State varchar(20),
    Sal_amt  decimal(8,2) not null check(Sal_amt != 0),
    Tgt_to_get decimal(6,2) not null check(Tgt_to_get != 0),
    Yid_sales decimal(6,2) not null,
    Remarks varchar(60)
);

insert into salesman_master(salesman_no, Salesman_name, Address1, Address2, City, Pincode, State, Sal_amt, Tgt_to_get, Yid_sales, Remarks) values
('S00001', 'Kiran', 'A/14', 'Worli', 'Bombay', '400002', 'Maharastra', 3000, 100, 50, 'Good'),
('S00002', 'Manish', '65', 'Nariman', 'Bombay', '400001', 'Maharastra', 3000, 200, 100, 'Good'),
('S00003', 'Ravi', 'P-7', 'Bandra', 'Bombay', '4000032', 'Maharastra', 3000, 200, 100, 'Good'),
('S00004', 'Aashish', 'A/5', 'Juhu', 'Bombay', '4000044', 'Maharastra', 3500, 200, 150, 'Good');

select * from salesman_master;

create table sale_order(
	order_no varchar(6) primary key check(order_no like '%c'),
    order_date date,
    client_no varchar(6),
    Dely_Addr varchar(25),
    Salesman_no varchar(6),
    Dely_type char(1) default 'f' check (Dely_type in ('f', 'p')),
    Billed_yn char(1),
    Dely_date date,
    Order_status varchar(10) check(order_status in ('in process', 'fullfield', 'back order', 'cancelled')),
    foreign key (client_no) references client_master(client_no),
    foreign key (salesman_no) references salesman_master(salesman_no),
    check (Dely_date < order_date)
);

insert into sale_order(order_no, order_date, client_no, Dely_Addr, Salesman_no, Dely_type, Billed_yn, Dely_date, Order_status) values
('O19001', 12-Jan-96, 'C00001', F, N, 'S00001', 20-Jan-96, 'In process'),
('O19002', 25-Jan-96, 'C00002', P, N, 'S00002', 27-Jan-96, 'Canclled');

create table sale_order_details(
	order_no varchar(6),
    Product_no varchar(6),
    Qty_ordered int(8),
    Qty_disp int(8),
    Product_rate decimal(10,2),
    primary key (order_no, product_no),
    foreign key (order_no) references sale_order(order_no),
    foreign key (Product_no) references product_master(Product_no)
);