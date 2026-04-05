--Amacımız: 814 duplicate'in hangi review_id'lerde olduğunu bulmak.
--Adım Adım Düşünelim:
--1. GROUP BY → "Grupla"
GROUP BY review_id
```
> "Aynı review_id'ye sahip satırları bir araya getir."

Örneğin:
```
review_id: ABC → 1 satır   (normal)
review_id: XYZ → 2 satır   (duplicate!)
review_id: DEF → 3 satır   (çok kötü!)
2. COUNT(*) → "Her grupta kaç satır var?"
COUNT(*) AS tekrar_sayisi
--"Her review_id'nin kaç kez göründüğünü say."
---3. HAVING → "Grupları filtrele"
HAVING COUNT(*) > 1
```
> "Sadece 1'den fazla tekrar edenleri göster."

❓ **WHERE ile farkı ne?**
```
WHERE   → satırları filtreler  (GROUP BY'dan ÖNCE)
HAVING  → grupları filtreler   (GROUP BY'dan SONRA)
4. ORDER BY DESC → "En çok tekrar edenden başla"
ORDER BY tekrar_sayisi DESC
5. LIMIT 10 → "Sadece ilk 10'u göster"
LIMIT 10 --Tablo çok büyük olabilir, önce ilk 10'a bakalım.

SELECT review_id,
count(*) as tekrar_sayisi
FROM `third-harbor-301722.Olist.olist_order_reviews_dataset` 
group by review_id
having count(*) > 1
order by tekrar_sayisi desc
limit 10


SELECT *
FROM `third-harbor-301722.Olist.olist_order_reviews_dataset` 
where review_id = "ddc52555ca27b0fe67d5255147682d2d"
-- BULGU: review_id tekrar ediyor ama order_id farklı
-- Aynı yorum 3 farklı siparişe bağlanmış
-- ÇÖZÜM: Analizde DISTINCT kullanılacak

-- ==========================================
-- OLIST - VERİ KALİTESİ
-- ==========================================

-- 1. Duplicate review_id'leri bul
SELECT
  review_id,
  COUNT(*) AS tekrar_sayisi
FROM `third-harbor-301722.Olist.olist_order_reviews_dataset`
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY tekrar_sayisi DESC
LIMIT 10;
-- Sonuç: 10 review_id bulundu, her biri 3 kez tekrar ediyor

-- 2. Duplicate olan review_id'nin detayı
SELECT *
FROM `third-harbor-301722.Olist.olist_order_reviews_dataset`
WHERE review_id = 'ddc52555ca27b0fe67d5255147682d2d';
-- Sonuç: review_id ve score aynı AMA order_id 3 FARKLI! 🚨
-- ÇÖZÜM: Analizde DISTINCT kullanılacak

-- 3. Orders tablosu NULL kontrolü
SELECT
  COUNTIF(order_id IS NULL)                     AS order_id_null,
  COUNTIF(customer_id IS NULL)                  AS customer_id_null,
  COUNTIF(order_status IS NULL)                 AS status_null,
  COUNTIF(order_purchase_timestamp IS NULL)     AS purchase_null,
  COUNTIF(order_approved_at IS NULL)            AS approved_null,
  COUNTIF(order_delivered_carrier_date IS NULL) AS carrier_null,
  COUNTIF(order_delivered_customer_date IS NULL) AS delivered_null,
  COUNTIF(order_estimated_delivery_date IS NULL) AS estimated_null
FROM `third-harbor-301722.Olist.olist_orders_dataset`;

-- Sonuçlar:
-- order_approved_at        → 160  NULL ⚠️  (onaylanmamış siparişler)
-- order_delivered_carrier  → 1783 NULL 🚨  (kargoya verilmemiş)
-- order_delivered_customer → 2965 NULL 🚨  (teslim edilmemiş)
-- ÇÖZÜM: Teslimat analizinde bu siparişler filtrelenecek

SELECT order_status,
count(*) as adet
FROM `third-harbor-301722.Olist.olist_orders_dataset`
group by order_status
order by adet desc
--canceled + unavailable + invoiced + processing + created + approved
--= 625 + 609 + 314 + 301 + 5 + 2 = 1856 sipariş
-- 4. Order status dağılımı
-- delivered   → 96478 (%97) ✅
-- shipped     → 1107
-- canceled    → 625
-- unavailable → 609
-- Karar: Teslimat analizinde WHERE order_status = 'delivered' kullanılacak
--canceled    → 625  sipariş (iptal edildi)
--unavailable → 609  sipariş (ürün yok)
--invoiced    → 314  sipariş (henüz faturalandı)
--processing  → 301  sipariş (hâlâ işlemde)
--created     → 5    sipariş
