--создаем и заполняем табличку данными из примера
CREATE TABLE contacts (
   contact_id INT,
   contact_name TEXT,
   assigned_by_id INT,
   phone JSONB
);

INSERT INTO contacts (contact_id, contact_name, assigned_by_id, phone) VALUES 
  (665928, 'Настасья', 46900, '[{"ID": "2681003", "VALUE_TYPE": "WORK", "VALUE": "79223819584", "TYPE_ID": "PHONE"}]'),
  (665571, 'НатальЯ', 105569, '[{"ID": "2679103", "VALUE_TYPE": "WORK", "VALUE": "+375291129062", "TYPE_ID": "PHONE"}]'),
  (650989, 'Мария', 105964, '[{"ID": "2610034", "VALUE_TYPE": "WORK", "VALUE": "+4993450324", "TYPE_ID": "PHONE"}, {"ID": "2610054", "VALUE_TYPE": "WORK", "VALUE": "+7925222118", "TYPE_ID": "PHONE"}]'),
  (657190, 'Виктор', 62855, '[{"ID": "2639444", "VALUE_TYPE": "WORK", "VALUE": "+2921952 790 7794", "TYPE_ID": "PHONE"}, {"ID": "2641587", "VALUE_TYPE": "WORK", "VALUE": "+99951230054", "TYPE_ID": "PHONE"}, {"ID": "2671751", "VALUE_TYPE": "WORK", "VALUE": "+111222929151", "TYPE_ID": "PHONE"}]'),
  (656334, 'johnny', 229, '[{"ID": "2634699", "VALUE_TYPE": "WORK", "VALUE": "+112349876", "TYPE_ID": "PHONE"}, {"ID": "2634739", "VALUE_TYPE": "WORK", "VALUE": "11124680292", "TYPE_ID": "PHONE"}, {"ID": "2634740", "VALUE_TYPE": "WORK", "VALUE": "+394818192983", "TYPE_ID": "PHONE"}]');


--непосредственно скрипт, можно оформить в виде view 
SELECT CNT, COUNT(contact_id) * 1.0 / SUM(COUNT(contact_id)) OVER () AS ratio
FROM (
  SELECT contact_id, COUNT(CASE WHEN specs."TYPE_ID" = 'PHONE' THEN "VALUE" END) CNT 
  FROM contacts 
  CROSS JOIN LATERAL jsonb_to_recordset(phone) AS specs("ID" TEXT, "VALUE" TEXT, "VALUE_TYPE"  TEXT, "TYPE_ID" TEXT)
  GROUP BY contact_id
) tbl
GROUP BY CNT

