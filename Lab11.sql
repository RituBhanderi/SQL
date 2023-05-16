SELECT warehouse_name,state
FROM warehouses
LEFT JOIN
locations
ON warehouses. location_id = locations.location_id
UNION
SELECT warehouse_name,state
FROM warehouses
RIGHT JOIN locations
ON warehouses.location_id = locations.location_id;