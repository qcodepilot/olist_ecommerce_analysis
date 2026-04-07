-- 1. Genel ortalama puan

SELECT  
round(avg(review_score)) as ortalama_puan,
count(*) as toplam_yorum,
count(distinct order_id) as yorumlanan_siparis
FROM `third-harbor-301722.Olist.olist_order_reviews_dataset` 
-- Sonuç: Ortalama puan 4.0, toplam 99,224 yorum, 98,673  sipariş yorumlandı → ✅
-- 2. Puan dağılımı
SELECT
  review_score AS puan,
  COUNT(*) AS yorum_adedi,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS yuzde
FROM `third-harbor-301722.Olist.olist_order_reviews_dataset`
GROUP BY review_score
ORDER BY review_score DESC;
--puan 5 → 57,328 yorum → %57.78 🟢
--puan 4 → 19,142 yorum → %19.29 🟢
--puan 3 →  8,179 yorum → %8.24  🟡
--puan 2 →  3,151 yorum → %3.18  🔴
--puan 1 → 11,424 yorum → %11.51 🔴
-- 3. Kategori bazında ortalama puan (en düşük 10)
SELECT
  t.string_field_1                AS kategori,
  ROUND(AVG(r.review_score), 2)  AS ortalama_puan,
  COUNT(r.review_id)             AS yorum_adedi
FROM `third-harbor-301722.Olist.olist_order_reviews_dataset` r
JOIN `third-harbor-301722.Olist.olist_orders_dataset` o
  ON r.order_id = o.order_id
JOIN `third-harbor-301722.Olist.olist_order_items_dataset` i
  ON o.order_id = i.order_id
JOIN `third-harbor-301722.Olist.olist_products_dataset` pr
  ON i.product_id = pr.product_id
JOIN `third-harbor-301722.Olist.olist_product_category_name_translation` t
  ON pr.product_category_name = t.string_field_0
WHERE t.string_field_1 != 'product_category_name_english' --"string_field_1 değeri tam olarak 'product_category_name_english' olan satırı getirme!"
GROUP BY kategori
HAVING COUNT(r.review_id) > 100
ORDER BY ortalama_puan ASC
LIMIT 10;
--office_furniture         → 3.49  ⚠️ (en düşük!)
--fashion_male_clothing    → 3.64  ⚠️
--fixed_telephony          → 3.68  ⚠️
--audio                    → 3.82  ⚠️
--home_confort             → 3.83  ⚠️
--construction_tools_safety→ 3.84  ⚠️
--bed_bath_table           → 3.89  (11,137 yorum!)
--furniture_decor          → 3.90
--furniture_living_room    → 3.90
--computers_accessories    → 3.93