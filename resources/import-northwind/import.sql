\set nw_categories :cwd categories.csv
\set nw_customers :cwd customers.csv
\set nw_employees :cwd employees.csv
\set nw_employee_territories :cwd employee-territories.csv
\set nw_order_details :cwd order-details.csv
\set nw_orders :cwd orders.csv
\set nw_products :cwd products.csv
\set nw_regions :cwd regions.csv
\set nw_shippers :cwd shippers.csv
\set nw_suppliers :cwd suppliers.csv
\set nw_territories :cwd territories.csv

START TRANSACTION;

CREATE EXTENSION IF NOT EXISTS file_fdw;

CREATE SERVER northwind FOREIGN DATA WRAPPER file_fdw;

CREATE FOREIGN TABLE nw_categories (
    categoryid int,
    categoryname varchar(15),
    description text,
    picture bytea
)
SERVER northwind
OPTIONS (
    filename :'nw_categories',
    format 'csv',
    header 'true',
    delimiter '|'
);

CREATE FOREIGN TABLE nw_customers (
    customerid char(5),
    companyname varchar(40),
    contactname varchar(30),
    contacttitle varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postalcode varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24)
)
SERVER northwind
OPTIONS (
    filename :'nw_customers',
    format 'csv',
    header 'true',
    delimiter '|'
);

CREATE FOREIGN TABLE nw_employees (
    employeeid int,
    lastname varchar(20),
    firstname varchar(10),
    title varchar(30),
    titleofcourtesy varchar(25),
    birthdate date,
    hiredate date,
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postalcode varchar(10),
    country varchar(15),
    homephone varchar(24),
    extension varchar(4),
    photo bytea,
    notes text,
    reportto int,
    photopath varchar(255)
)
SERVER northwind
OPTIONS (
    filename :'nw_employees',
    format 'csv',
    header 'true',
    delimiter '|',
    null 'NULL'
);

CREATE FOREIGN TABLE nw_employee_territories (
    employeeid int,
    territoryid varchar(20)
)
SERVER northwind
OPTIONS (
    filename :'nw_employee_territories',
    format 'csv',
    header 'true',
    delimiter '|'
);

CREATE FOREIGN TABLE nw_order_details (
    orderid int,
    productid int,
    unitprice money,
    quantity smallint,
    discount real
)
SERVER northwind
OPTIONS (
    filename :'nw_order_details',
    format 'csv',
    header 'true',
    delimiter '|'
);

CREATE FOREIGN TABLE nw_orders (
    orderid int,
    customerid char(5),
    employeeid int,
    orderdate date,
    requireddate date,
    shippeddate date,
    shipvia int,
    freight money,
    shipname varchar(40),
    shipaddress varchar(60),
    shipcity varchar(15),
    shipregion varchar(15),
    shippostalcode varchar(10),
    shipcountry varchar(15)
)
SERVER northwind
OPTIONS (
    filename :'nw_orders',
    format 'csv',
    header 'true',
    delimiter '|',
    null 'NULL'
);

CREATE FOREIGN TABLE nw_products (
    productid int,
    productname varchar(40),
    supplierid int,
    categoryid int,
    quantityperunit varchar(20),
    unitprice money,
    unitsinstock smallint,
    unitsonorder smallint,
    reorderlevel smallint,
    discontinued bit
)
SERVER northwind
OPTIONS (
    filename :'nw_products',
    format 'csv',
    header 'true',
    delimiter '|',
    null 'NULL'
);

CREATE FOREIGN TABLE nw_regions (
    regionid int,
    regiondescription char(50)
)
SERVER northwind
OPTIONS (
    filename :'nw_regions',
    format 'csv',
    header 'true',
    delimiter '|'
);

CREATE FOREIGN TABLE nw_shippers (
    shipperid int,
    companyname varchar(40),
    phone varchar(24)
)
SERVER northwind
OPTIONS (
    filename :'nw_shippers',
    format 'csv',
    header 'true',
    delimiter '|'
);

CREATE FOREIGN TABLE nw_suppliers (
    supplierid int,
    companyname varchar(40),
    contactname varchar(30),
    contacttitle varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postalcode varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24),
    homepage text
)
SERVER northwind
OPTIONS (
    filename :'nw_suppliers',
    format 'csv',
    header 'true',
    delimiter '|',
    null 'NULL'
);

CREATE FOREIGN TABLE nw_territories (
    territoryid varchar(20),
    territorydescription char(50),
    regionid int
)
SERVER northwind
OPTIONS (
    filename :'nw_territories',
    format 'csv',
    header 'true',
    delimiter '|'
);

CREATE GRAPH northwind_graph;
SET graph_path = northwind_graph;

LOAD FROM nw_categories AS r CREATE (:categories =to_jsonb(r));
LOAD FROM nw_customers AS r CREATE (:customers =to_jsonb(r));
LOAD FROM nw_employees AS r CREATE (:employees =to_jsonb(r));
LOAD FROM nw_orders AS r CREATE (:orders =to_jsonb(r));
LOAD FROM nw_products AS r CREATE (:products =to_jsonb(r));
LOAD FROM nw_regions AS r CREATE (:regions =to_jsonb(r));
LOAD FROM nw_shippers AS r CREATE (:shippers =to_jsonb(r));
LOAD FROM nw_suppliers AS r CREATE (:suppliers =to_jsonb(r));
LOAD FROM nw_territories AS r CREATE (:territories =to_jsonb(r));

CREATE PROPERTY INDEX ON categories (categoryid);
CREATE PROPERTY INDEX ON customers (customerid);
CREATE PROPERTY INDEX ON employees (employeeid);
CREATE PROPERTY INDEX ON orders (orderid);
CREATE PROPERTY INDEX ON products (productid);
CREATE PROPERTY INDEX ON regions (regionid);
CREATE PROPERTY INDEX ON shippers (shipperid);
CREATE PROPERTY INDEX ON suppliers (supplierid);
CREATE PROPERTY INDEX ON territories (territoryid);

LOAD FROM nw_employee_territories AS r
MATCH (e:employees), (t:territories)
WHERE e.employeeid = to_jsonb(r.employeeid) AND
      t.territoryid = to_jsonb(r.territoryid)
CREATE (e)-[:belongs_to]->(t);

LOAD FROM nw_order_details AS r
MATCH (o:orders), (p:products)
WHERE o.orderid = to_jsonb(r.orderid) AND
      p.productid = to_jsonb(r.productid)
CREATE (o)-[:contains {unitprice: r.unitprice,
                       quantity: r.quantity,
                       discount: r.discount}]->(p);

MATCH (e:employees), (b:employees) WHERE e.reportto = b.employeeid
CREATE (e)-[:reports_to]->(b);

MATCH (s:suppliers), (p:products) WHERE s.supplierid = p.supplierid
CREATE (s)-[:supplies]->(p);

MATCH (p:products), (c:categories) WHERE p.categoryid = c.categoryid
CREATE (p)-[:is_part_of]->(c);

MATCH (t:territories), (r:regions) WHERE t.regionid = r.regionid
CREATE (t)-[:is_in]->(r);

MATCH (c:customers), (o:orders) WHERE c.customerid = o.customerid
CREATE (c)-[:makes]->(o);

MATCH (e:employees), (o:orders) WHERE e.employeeid = o.employeeid
CREATE (e)-[:manages]->(o);

MATCH (o:orders), (s:shippers) WHERE o.shipvia = s.shipperid
CREATE (o)-[:is_delivered_by]->(s);

COMMIT;
