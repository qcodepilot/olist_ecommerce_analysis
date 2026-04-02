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