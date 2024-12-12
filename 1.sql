create database sales;
use sales;

create table client_master(
	client_no varchar(6) primary key check(client_no like '%C' and length(client_no)=6),
    Name varchar(20) not null,
    address1 varchar(30),
    address2 varchar(30),
    city varchar(15),
    pincode int(8),
    state varchar(15),
    bal_due decimal(10,2)
);

insert into client_master (client_no, name, city, pincode, state, bal_due) values
('C00001', 'Ivan Bayross', 'Bombay', 400054, 'Maharashtra', 15000),
('C00002', 'Vandana Saitwal', 'Madras', 780001, 'Tamil Nadu', 0),
('C00003', 'Pramada Jaguste', 'Bombay', 400057, 'Maharashtra', 5000),
('C00004', 'Basu Navindgi', 'Bombay', 400056, 'Maharashtra', 0),
('C00005', 'Ravi Sreedharan', 'Delhi', 100001, 'Delhi', 2000),
('C00006', 'Rukmini', 'Bombay', 400050, 'Maharashtra', 0);

select * from client_master;

create table product_master(
	product_no varchar(6) primary key check(product_no like '%P' and length(product_no)=6),
    description varchar(15) not null,
    profit_percent float(4,2) not null,
    unit_measure varchar(10) not null,
    qty_on_hand int(8) not null,
    reorder_lvl int(8) not null,
    sell_price decimal(8,2) not null check(sell_price != 0),
    cost_price decimal(8,2) not null check(cost_price != 0)
);

insert into product_master (product_no, description, profit_percent, unit_measure, qty_on_hand, reorder_lvl, sell_price, cost_price) values
('P00001', '1.44 Floppies', 5, 'Piece', 100, 20, 525, 500),
('P03453', 'moniters', 6, 'Piece', 10, 3, 12000, 11280),
('P06734', 'mouse', 5, 'Piece', 20, 5, 1050, 1000),
('P07865', '1.22 Floppies', 5, 'Piece', 100, 20, 525, 500),
('P07868', 'keyboards', 2, 'Piece', 10, 3, 3150, 3050),
('P07885', 'CD Drive', 2.5, 'Piece', 10, 3, 5250, 5100),
('P07965', '540 HHD', 4, 'Piece', 10, 3, 8400, 8000),
('P07975', '1.44 Drive', 5, 'Piece', 10, 3, 1050, 1000),
('P08865', '1.22 Drive', 5, 'Piece', 2, 3, 1050, 1000);

select * from product_master;

create table salesman_master(
	salesman_no varchar(6) primary key check(salesman_no like '%S'),
    salesman_name varchar(20) not null,
    address1 varchar(30) not null,
    address2 varchar(30),
    city varchar(20),
    pincode varchar(8),
    state varchar(20),
    sal_amt  decimal(8,2) not null check(sal_amt != 0),
    tgt_to_get decimal(6,2) not null check(tgt_to_get != 0),
    yid_sales decimal(6,2) not null,
    remarks varchar(60)
);

insert into salesman_master(salesman_no, Salesman_name, Address1, Address2, City, Pincode, State, Sal_amt, Tgt_to_get, Yid_sales, Remarks) values
('S00001', 'Kiran', 'A/14', 'Worli', 'Bombay', '400002', 'Maharastra', 3000, 100, 50, 'Good'),
('S00002', 'Manish', '65', 'Nariman', 'Bombay', '400001', 'Maharastra', 3000, 200, 100, 'Good'),
('S00003', 'Ravi', 'P-7', 'Bandra', 'Bombay', '4000032', 'Maharastra', 3000, 200, 100, 'Good'),
('S00004', 'Aashish', 'A/5', 'Juhu', 'Bombay', '4000044', 'Maharastra', 3500, 200, 150, 'Good');

select * from salesman_master;

create table sale_order(
	order_no varchar(6) primary key check(order_no like '%O'),
    order_date date,
    client_no varchar(6),
    dely_Addr varchar(25),
    salesman_no varchar(6),
    dely_type char(1) default 'F' check (dely_type in ('F', 'P')),
    billed_yn char(1),
    dely_date date,
    order_status varchar(10) check(order_status in ('in process', 'fullfield', 'back order', 'cancelled')),
    foreign key (client_no) references client_master(client_no),
    foreign key (salesman_no) references salesman_master(salesman_no),
    check (dely_date >= order_date)
);

insert into sale_order(order_no, order_date, client_no, dely_type, billed_yn, salesman_no, dely_date, order_status) values
('O19001', 12-1-96, 'C00001', 'F', 'N', 'S00001', 20-1-96, 'in process'),
('O19002', 25-1-96, 'C00002', 'P', 'N', 'S00002', 27-1-96, 'canclled'),
('O46865', 18-2-96, 'C00003', 'F', 'Y', 'S00003', 20-2-96, 'fulfield'),
('O19003', 03-4-96, 'C00001', 'F', 'Y', 'S00001', 07-4-96, 'fulfield'),
('O46866', 20-5-96, 'C00004', 'P', 'N', 'S00002', 22-5-96, 'cancelled'),
('O19008', 24-5-96, 'C00005', 'F', 'N', 'S00004', 26-5-96, 'in process');

create table sale_order_details(
	order_no varchar(6),
    product_no varchar(6),
    qty_ordered int(8),
    qty_disp int(8),
    product_rate decimal(10,2),
    primary key (order_no, product_no),
    foreign key (order_no) references sale_order(order_no),
    foreign key (product_no) references product_master(product_no)
);

insert into sale_order_details(order_no, product_no, qty_ordered, qty_disp, product_rate) values
('019001', 'P00001', 4, 4, 525),
('019001', 'P07965', 2, 1, 8400),
('019001', 'P07885', 2, 1, 5250),
('019002', 'P00001', 10, 0, 525),
('046865', 'P07868', 3, 3, 3150),
('046865', 'P07885', 3, 1, 5250),
('046865', 'P00001', 10, 10, 525),
('046865', 'P03453', 4, 4, 1050),
('019003', 'P03453', 2, 2, 1050),
('019003', 'P06734', 1, 1, 12000),
('046866', 'P07965', 1, 0, 8400),
('046866', 'P07975', 1, 0, 1050),
('019008', 'P00001', 10, 5, 525),
('019008', 'P07975', 5, 3, 1050);