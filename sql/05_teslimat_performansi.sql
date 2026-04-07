-- 1. Ortalama teslimat süresi (gün)
SELECT
  AVG(DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY)) AS ort_teslimat_gun,
  AVG(DATE_DIFF(DATE(order_estimated_delivery_date), DATE(order_purchase_timestamp), DAY)) AS ort_tahmini_gun
FROM `third-harbor-301722.Olist.olist_orders_dataset`
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
--order_purchase_timestamp      → sipariş tarihi
--order_delivered_customer_date → gerçek teslimat
--order_estimated_delivery_date → tahmini teslimat
--Tahmini teslimat(ortalama) → 24 gün
--Gerçek teslimat(ortalama teslimat)  → 12 gün
--Fark → 12 gün ERKEN! 🎉
--Olist müşterilere çok iyimser tahmin vermiyor, aksine erken teslim ediyor! Bu çok olumlu bir bulgu.
-- 2. Gecikmeli teslimat oranı
SELECT
  COUNT(*) AS toplam_siparis,
  COUNTIF(order_delivered_customer_date > order_estimated_delivery_date) AS geciken_siparis,
  ROUND(COUNTIF(order_delivered_customer_date > order_estimated_delivery_date) * 100.0 / COUNT(*), 2) AS gecikme_yuzdesi
FROM `third-harbor-301722.Olist.olist_orders_dataset`
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
 -- Gerçek teslimat > Tahmini teslimat → GECİKTİ!
--Toplam sipariş  → 96,470
--Geciken sipariş → 7,826
--Gecikme oranı   → %8.11
--"Her 12 siparişten 1'i gecikmeli teslim ediliyor.
--7,826 müşteri olumsuz deneyim yaşadı."
-- 3. Gecikme vs review puanı
SELECT
  CASE 
    WHEN order_delivered_customer_date > order_estimated_delivery_date 
    THEN 'Gecikmeli'
    ELSE 'Zamanında'
  END AS teslimat_durumu,
  ROUND(AVG(r.review_score), 2) AS ortalama_puan,
  COUNT(*) AS siparis_adedi
FROM `third-harbor-301722.Olist.olist_orders_dataset` o
JOIN `third-harbor-301722.Olist.olist_order_reviews_dataset` r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY teslimat_durumu;
--CASE WHEN → koşula göre yeni sütun oluşturur
--THEN      → koşul doğruysa bu değeri ver
--ELSE      → koşul yanlışsa bu değeri ver
--END       → CASE'i kapat
--Zamanında  → 4.29 puan | 88,653 sipariş ✅
--Gecikmeli  → 2.57 puan |  7,700 sipariş 🚨
--Gecikme → puanı 4.29'dan 2.57'ye düşürüyor!
--Fark    → 1.72 puan (%40 düşüş!)
--Zamanında teslimat  → 4.3/5 puan
--Gecikmeli teslimat  → 2.6/5 puan

--Geciken 7,700 müşteri mutsuz!
--Teslimat sürecini iyileştirmek
--en kritik öncelik olmalı.