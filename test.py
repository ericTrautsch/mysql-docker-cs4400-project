a=(('''SELECT p.part_id,  p.description,  s.storage_area_id,  s.area,  s.location, i.quantity FROM Inventory i JOIN Part p ON i.part_id = p.part_id JOIN StorageArea s ON i.storage_area_id = s.storage_area_id WHERE p.part_id = 1;''', 'Find Part Query','Where can I find part id a specific part in the warehouse to pick and add to an outgoing shipment? (Using part_id 1 as an example)')
               , ('''SELECT SUM(i.quantity * i.cost_per_unit) AS total_value FROM Inventory i WHERE i.part_id = 1;''', 'Find Part Value', 'What is the total value of all parts of a certain type stored in the warehouse? (Using part id 1)')
               , ('''SELECT * FROM StorageArea s WHERE NOT EXISTS ( SELECT i.storage_area_id FROM Inventory i WHERE i.storage_area_id = s.storage_area_id );''', 'Find Empty Storage Areas', 'Which storage areas can accommodate a new part type?')
               , ('''SELECT p.part_id, p.description, p.manufacturer, p.material_type, SUM(o.quantity) AS total_outgoing_quantity FROM Part p JOIN Outgoing o ON p.part_id = o.part_id GROUP BY p.part_id, p.description, p.manufacturer, p.material_type HAVING total_outgoing_quantity = ( SELECT MAX(total_outgoing_quantity) FROM ( SELECT part_id, SUM(quantity) AS total_outgoing_quantity FROM Outgoing GROUP BY part_id ) AS outgoing_summary );''', 'Highest Outgoing Demand', 'What part is in the highest outgoing demand? (involves join, aggregation, and subquery)')
               , ('''SELECT SUM(o.quantity * o.profit_per_unit) AS total_profit FROM Outgoing o WHERE o.placed_on >= DATE_FORMAT(NOW(), '%Y-01-01') AND o.placed_on < DATE_FORMAT(NOW(), '%Y-%m-%d');''', 'Profits This Year' ,'What are our profits for the current year? (involves join and aggregation)'))

for all in a:
    print(f'{all[1]}: \n{all[2]}\n{all[0]}')