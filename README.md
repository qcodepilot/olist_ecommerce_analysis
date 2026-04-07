# 🛒 Olist E-Commerce Data Analysis

SQL ve BigQuery kullanarak Brezilya'nın en büyük 
e-ticaret platformu Olist'in gerçek verilerini analiz ettim.

---

## 🛠️ Kullanılan Teknolojiler
- Google BigQuery
- SQL
- VS Code
- GitHub

---

## 📁 Veri Seti
- 9 tablo, 99,441 sipariş
- 2016-2018 dönemi
- Kaynak: [Kaggle - Olist Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---

## 🔍 Analiz Edilen İş Vakaları

### 1. Gelir Analizi
- Toplam gelir: 16M R$
- 2016→2017: 150x büyüme
- AOV stabil: ~154 R$ (sağlıklı büyüme)
- Kredi kartı ödemelerin %76'sını oluşturuyor

### 2. Müşteri Memnuniyeti
- Genel ortalama: 4.0/5
- %77 müşteri 4-5 yıldız verdi
- office_furniture en düşük kategori: 3.49
- bed_bath_table: düşük puan + 11K yorum (büyük risk!)

### 3. Teslimat Performansı
- Ortalama teslimat: 12.5 gün
- Tahminden 12 gün erken teslim ✅
- %8 sipariş gecikmeli
- Gecikme müşteri puanını %40 düşürüyor 🚨

---

## 💡 Temel Öneriler
1. Teslimat sürecini iyileştir → en kritik!
2. office_furniture kategorisini incele
3. bed_bath_table kalitesini artır
4. Voucher stratejisini gözden geçir

---

## 📊 Sunum
[Olist E-Commerce Analizi Sunumu](https://docs.google.com/presentation/d/19QFKtsUF1eUUqs6-gfBVFSgZebkt1CAFfFtqBlZwm7c/edit?slide=id.p#slide=id.p)

---

## 📂 Dosya Yapısı
```
olist_ecommerce_analysis/
├── sql/
│   ├── 01_pk_testleri.sql
│   ├── 02_veri_kalitesi.sql
│   ├── 03_gelir_analizi.sql
│   ├── 04_musteri_memnuniyeti.sql
│   └── 05_teslimat_performansi.sql
└── notes/
    └── analiz_notlari.md
```