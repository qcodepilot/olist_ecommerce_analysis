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