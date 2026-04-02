SELECT count(order_id) as toplam_satir,
         count(DISTINCT order_id) as benzersiz_satir,
         countif(order_id IS NULL) as null_degerler
         FROM `third-harbor-301722.Olist.olist_orders_dataset`
         -- Sonuç: toplam: 99441 | benzersiz: 99441 | null: 0 → ✅ PK ONAYLANDI
SELECT count(customer_id) as toplam_satir,
count(distinct customer_id) as benzersiz_deger,
countif(customer_id is null) as null_sayisi
 FROM `third-harbor-301722.Olist.olist_customers_dataset` 
 -- Sonuç: toplam: 99441 | benzersiz: 99441 | null: 0 → ✅ PK ONAYLANDI
 SELECT count(product_id) as toplam_satir,
count(distinct product_id) as benzersiz_deger,
countif(product_id is null) as null_sayisi

 FROM `third-harbor-301722.Olist.olist_products_dataset` 
 -- Sonuç: toplam: 32951 | benzersiz: 32951 | null: 0 → ✅ PK ONAYLANDI
 SELECT count(review_id) as toplam_satir,
       count(distinct review_id) as benzersiz_deger,
       countif(review_id is null) as null_sayisi

FROM `third-harbor-301722.Olist.olist_order_reviews_dataset` 
 -- Sonuç: toplam: 99224 | benzersiz: 98410 | null: 0 → ❌ 814 DUPLICATE!
SELECT count(seller_id) as toplam_satir,
        count(distinct seller_id) as benzersiz_deger,
        countif(seller_id is null) as null_sayisi
FROM `third-harbor-301722.Olist.olist_sellers_dataset` 
-- Sonuç: toplam: 3095 | benzersiz: 3095 | null: 0 → ✅ PK ONAYLANDI
-- 1. orders    → ✅ 99441 | 99441 | 0
-- 2. customers → ✅ 99441 | 99441 | 0
-- 3. products  → ✅ 32951 | 32951 | 0
-- 4. sellers   → ✅ 3095  | 3095  | 0
-- 5. reviews   → ❌ 99224 | 98410 | 0 → 814 DUPLICATE!