DROP GRAPH northwind_graph CASCADE;
DROP FOREIGN TABLE nw_categories, nw_customers, nw_employees,
                   nw_employee_territories, nw_order_details, nw_orders,
                   nw_products, nw_regions, nw_shippers, nw_suppliers,
                   nw_territories;
DROP SERVER northwind;
