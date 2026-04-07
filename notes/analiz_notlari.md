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

--AYLIK GELİR TRENDİ BULMA
--DATE_TRUNCH(tarih, MONTH) > TARİHİ AY BAŞINA YUVARLAR
--ÖRNEK: 2017-08-15  > 2017-08-01
--PAYMENTS TABLOSUNDA TARİH YOK O YÜZDEN "ORDERS TABLOSU İLE" JOİN YAPACAĞIZ.
SELECT 
DATE_TRUNC(o.order_purchase_timestamp, month) as ay,
round(sum(p.payment_value))  as aylik_gelir,
count(distinct o.order_id)  as siparis_adedi

FROM `third-harbor-301722.Olist.olist_orders_dataset` o
join `third-harbor-301722.Olist.olist_order_payments_dataset` p
on o.order_id = p.order_id
where o.order_status = "delivered"
group by ay
ORDER BY ay;

--yıl bazlı yıllık gelir ve siparis adetlerini- ortalam siparişleri değerlendirme
select 
extract(year FROM o.order_purchase_timestamp) as yil,
round(sum(p.payment_value)) as yillik_gelir,
count(distinct o.order_id) as siparis_adedi,
round(avg(p.payment_value)) as ortalama_siparis_degeri
FROM `third-harbor-301722.Olist.olist_orders_dataset` o
join `third-harbor-301722.Olist.olist_order_payments_dataset` p
on o.order_id = p.order_id
where o.order_status = "delivered"
group by yil
order by yil;
### Sorgu 2b: Yıllık Gelir Özeti
| Yıl  | Gelir      | Sipariş | Ort. Sipariş |
|------|-----------|---------|--------------|
| 2016 | 46,586 R$ | 266     | 165 R$       |
| 2017 | 6.9M R$   | 43,428  | 151 R$       |
| 2018 | 8.5M R$   | 52,783  | 154 R$       |

- 2016→2017: ~150x büyüme (yeni platform)
- 2017→2018: ~1.2x büyüme (olgunlaşma)
- AOV stabil: 151-165 R$ arası
-Neden AOV sabit kaldı?
Daha fazla müşteri geldi    ✅
Daha fazla sipariş verildi  ✅
Ama sepet büyüklüğü aynı    🤔
Bunun birkaç sebebi olabilir:
1. Müşteri profili değişmedi
Yeni gelen müşteriler de aynı fiyat aralığında alışveriş yapıyor. Platform büyüdü ama hedef kitle aynı kaldı.
2. Ürün kategorileri değişmedi
En çok satan kategoriler hep aynı — bed & bath, health & beauty. Bunların fiyat aralığı sabit.
3. Sağlıklı büyüme işareti
AOV düşseydi → "indirimle müşteri çekiyorlar, karlılık azalıyor" derdik.
AOV yükselseydi → "pahalılaştı, müşteri kaybedebilirler" derdik.
AOV stabil → büyüme organik ve sağlıklı! ✅
"Olist 2017'den 2018'e siparişlerini %21 artırırken
ortalama sepet değerini korudu → sağlıklı büyüme"
### Kategori Analizi
- 2016: 29 kategori
- 2017: 71 kategori (+42 yeni!)
- 2018: 70 kategori (stabilleşti)
- 2017'de eklenen en karlı kategori: stationery (308K R$)
- En yüksek AOV: computers (~1,554 R$ / sipariş)
### Ödeme Yöntemi Analizi
- Kredi kartı: %76 sipariş, 12.5M R$ gelir
- Boleto: %20 sipariş (Brezilya'ya özgü ödeme)
- Voucher: düşük AOV (66 R$) → indirim kullanıcıları
- not_defined: 3 sipariş, veri kalitesi sorunu
## MÜŞTERİ MEMNUNİYETİ

### Sorgu 1: Genel Puan
- Ortalama: 4.0/5 ✅
- Toplam yorum: 99,224

### Sorgu 2: Puan Dağılımı
- %57 → 5 yıldız 🟢
- %11 → 1 yıldız 🔴
- Mutsuz müşteriler direkt 1 veriyor!

### Sorgu 3: En Düşük Kategoriler
- office_furniture → 3.49 (en kötü)
- fixed_telephony  → 3.68
- bed_bath_table   → 3.89 ama 11K yorum! (büyük risk)
- Öneri: Mobilya ve elektronik kategorilerinde
  iyileştirme yapılmalı
  ## TESLİMAT PERFORMANSI

### Sorgu 1: Ortalama Teslimat Süresi
- Gerçek teslimat: ~12.5 gün
- Tahmini teslimat: ~24.4 gün
- Olist erken teslim ediyor! ✅

### Sorgu 2: Gecikme Oranı
- Toplam sipariş: 96,470
- Geciken sipariş: 7,826
- Gecikme oranı: %8.11
- Her 12 siparişten 1'i gecikmeli!

### Sorgu 3: Gecikme vs Puan
- Zamanında → 4.29 puan ✅
- Gecikmeli  → 2.57 puan 🚨
- Fark: %40 düşüş!
- EN KRİTİK BULGU: Teslimat gecikmesi 
  müşteri memnuniyetini %40 düşürüyor!
  
  # Olist E-Commerce Data Analysis

## 📌 Proje Hakkında
Brezilya'nın en büyük e-ticaret platformu Olist'in 
gerçek verilerini BigQuery + SQL kullanarak analiz ettim.

## 🛠️ Kullanılan Teknolojiler
- Google BigQuery
- SQL
- VS Code
- GitHub

## 📊 Analiz Edilen İş Vakaları
1. Gelir Analizi
2. Müşteri Memnuniyeti
3. Teslimat Performansı

## 🔑 Temel Bulgular
- Toplam gelir: 16M R$ (2016-2018)
- 2016→2017: 150x büyüme
- Ortalama müşteri puanı: 4.0/5
- Gecikme müşteri memnuniyetini %40 düşürüyor
- Kredi kartı ödemelerin %76'sını oluşturuyor

## 📁 Dosya Yapısı
- sql/ → Tüm SQL sorguları
- notes/ → Analiz notları ve bulgular