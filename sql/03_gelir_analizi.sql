-- ==========================================
-- OLIST - GELİR ANALİZİ
-- ==========================================

-- 1. Toplam gelir
-- Sonuç: 16,008,872 R$ | 99,440 sipariş → ✅
SELECT
  ROUND(SUM(payment_value), 2) AS toplam_gelir,
  COUNT(DISTINCT order_id)     AS toplam_siparis
FROM `third-harbor-301722.Olist.olist_order_payments_dataset`;

-- 2. Aylık gelir trendi
-- Sonuç: 2016'dan 2018'e sürekli büyüme, Kasım 2017'de Black Friday zirvesi
SELECT
  DATE_TRUNC(o.order_purchase_timestamp, MONTH) AS ay,
  ROUND(SUM(p.payment_value), 2)                AS aylik_gelir,
  COUNT(DISTINCT o.order_id)                    AS siparis_adedi
FROM `third-harbor-301722.Olist.olist_orders_dataset` o
JOIN `third-harbor-301722.Olist.olist_order_payments_dataset` p
  ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY ay
ORDER BY ay;

-- 2b. En yüksek 5 ay (özet)
SELECT
  DATE_TRUNC(o.order_purchase_timestamp, MONTH) AS ay,
  ROUND(SUM(p.payment_value), 2)                AS aylik_gelir,
  COUNT(DISTINCT o.order_id)                    AS siparis_adedi
FROM `third-harbor-301722.Olist.olist_orders_dataset` o
JOIN `third-harbor-301722.Olist.olist_order_payments_dataset` p
  ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY ay
ORDER BY aylik_gelir DESC
LIMIT 5;

-- Ödeme yöntemi dağılımı
SELECT
  payment_type                    AS odeme_yontemi,
  COUNT(DISTINCT order_id)        AS siparis_adedi,
  ROUND(SUM(payment_value), 2)    AS toplam_gelir,
  ROUND(AVG(payment_value), 2)    AS ortalama_siparis
FROM `third-harbor-301722.Olist.olist_order_payments_dataset`
GROUP BY payment_type
ORDER BY toplam_gelir DESC;

credit_card → 76,505 sipariş | 12.5M R$  | ort: 163 R$
boleto      → 19,784 sipariş |  2.8M R$  | ort: 145 R$
voucher     →  3,866 sipariş |  379K R$  | ort:  66 R$
debit_card  →  1,528 sipariş |  217K R$  | ort: 143 R$
not_defined →      3 sipariş |    0 R$   | ort:   0 R$
💳 Kredi kartı dominant: 
   Siparişlerin %76'sı kredi kartıyla!

🎫 Voucher ilginç:
   3,866 sipariş ama ort. sadece 66 R$
   → İndirim kuponu kullananlar daha az harcıyor

💡 not_defined → 3 sipariş, gelir 0
   → Veri kalitesi sorunu, görmezden gel