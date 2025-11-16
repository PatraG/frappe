# ERPNext Docker Setup

Setup ERPNext v15 Stable dengan aplikasi:
- **ERPNext v15.88.1** - Core ERP System
- **HRMS v15.52.2** - Human Resource Management
- **CRM v1.56.2** - Customer Relationship Management
- **Insights v3.2.16** - Business Intelligence & Analytics
- **ERPNext Indonesia Localization v1.2.0** - Indonesian Tax Compliance (Coretax)

Built from official Frappe Docker image: `frappe/erpnext:v15.88.1`

## Persyaratan
- Docker
- Docker Compose

## Cara Menjalankan

### 1. Build Custom Image (First Time Only)
```bash
docker build -t custom-erpnext-with-indonesia:latest .
```

### 2. Start Services
```bash
docker compose up -d
```

### 3. Create Site (First Time Only)
```bash
docker compose --project-name frappe exec backend bench new-site frontend --no-mariadb-socket --admin-password=admin --db-root-password=admin --install-app erpnext --install-app hrms --install-app crm --install-app insights --install-app erpnext_indonesia_localization --set-default
```

Atau jalankan service create-site:
```bash
docker compose --project-name frappe up -d configurator create-site
```

### 4. Akses ERPNext
Buka browser dan akses: http://localhost:8080

**Login Credentials:**
- Username: Administrator
- Password: admin

## Perintah Berguna

### Melihat Logs
```bash
docker compose logs -f backend
```

### Stop Services
```bash
docker compose down
```

### Restart Services
```bash
docker compose restart
```

### Akses Bench Console
```bash
docker compose exec backend bash
```

### Update Apps
```bash
docker compose exec backend bench update --reset
```

### Backup Site
```bash
docker compose exec backend bench --site frontend backup
```

## ERPNext Indonesia Localization

Aplikasi ini menyediakan fitur untuk kepatuhan pajak Indonesia:

### Fitur Utama:
1. **Coretax XML Exporter** - Export Sales Invoice ke format XML DJP
2. **Coretax Importer** - Import data VAT dari DJP (Excel) ke ERPNext
3. **Tax Compliance** - Sesuai regulasi perpajakan Indonesia

### Setup Awal:

Sebelum menggunakan fitur eFaktur, import master data referensi dari folder `coretax_reference_master_data`:
- CoreTax Transaction Code Ref
- CoreTax Barang Jasa Ref  
- CoreTax Facility Stamp Ref
- CoreTax Additional Info Ref
- CoreTax Unit Ref

**Dokumentasi:** [ERPNext Indonesia Localization](https://github.com/agile-technica/erpnext-indonesia-localization)

## Volume Data
- `db-data`: Database MariaDB
- `sites`: Site files dan konfigurasi
- `logs`: Application logs
- `redis-*-data`: Redis cache dan queue data

## Troubleshooting

### Port 8080 sudah digunakan
Edit `docker-compose.yml` dan ubah port mapping pada service `frontend`:
```yaml
ports:
  - "8081:8080"  # Ubah 8080 ke port lain
```

### Reset Database
```bash
docker compose down -v
docker compose up -d
```
