# OLIST ANALİZ NOTLARI

---

## 1. GELİR ANALİZİ

### Sorgu 1: Toplam Gelir
**Soru:** Olist'in toplam geliri ne kadar?

**Kod:**
```sql
SELECT
  ROUND(SUM(payment_value), 2) AS toplam_gelir,
  COUNT(DISTINCT order_id)     AS toplam_siparis
FROM `third-harbor-301722.Olist.olist_order_payments_dataset`;
```

**Sonuç:**
- Toplam gelir: 16,008,872 R$
- Toplam sipariş: 99,440


---