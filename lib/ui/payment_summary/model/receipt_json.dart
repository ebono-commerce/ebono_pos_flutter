const jsonData = '''
{
  "invoice_number": "IN003/25/0000615",
  "invoice_date": "07/01/2025",
  "order_date": "07/01/2025",
  "outlet_address": {
    "name": "EBONO Alahalli Village O1",
    "full_address": "Survey No. 3/4,BBMP Number 24/918/130/385, Alahalli village, Uttarahalli Hobli, Bengaluru South Taluk, Bengaluru,560062",
    "phone_number": {
      "country_code": "91",
      "number": "9380673057"
    },
    "gstin_number": "29AAGCE1511K1ZP"
  },
  "customer": {
    "customer_name": "Admin",
    "phone_number": {
      "country_code": "+91",
      "number": "9222222222"
    }
  },
  "order_number": "10001151",
  "invoice_lines": [
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 237500
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 12500,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 237500,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 12500,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "f6421236-d05f-4142-8b09-c2bfeea83367",
      "order_line_id": "8553d97d-3b66-5e97-ba4b-950b5e851226",
      "sku_code": "10000683",
      "tax_code": "32041294",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Ujala Supreme 75ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 378000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 420000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 42000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 378000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 42000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "29c07f52-dc95-4bc1-a7dc-1f6b0fb5515e",
      "order_line_id": "61052400-e720-51cd-9b2a-13110001679a",
      "sku_code": "10000726",
      "tax_code": "96190010",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Whisper Choice Aloe XL 6N",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 500000
      },
      "tax_total": {
        "cent_amount": 38200,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 211800,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 38200,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "048b6b34-174f-4639-bc42-3a9b433a2f08",
      "order_line_id": "9e406154-d3d9-590b-8d53-49f4927ec862",
      "sku_code": "10000691",
      "tax_code": "33049920",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vency Nail Polish C066 6ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 500000
      },
      "tax_total": {
        "cent_amount": 38200,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 211800,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 38200,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "49262d5d-e80a-48ef-b783-09ed47f0ced2",
      "order_line_id": "ff8525fe-0d10-5a01-bb0d-ca1cf64fbca7",
      "sku_code": "10000692",
      "tax_code": "33049920",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vency Nail Polish C072 6ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 370000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 390000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 20000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 370000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 20000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "28a21ad3-9f7b-4ec7-aa3b-1f4a4a6b9aa9",
      "order_line_id": "f6c075e4-228c-5840-9914-7addba472c8b",
      "sku_code": "10000723",
      "tax_code": "34025000",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Wheel Detergent Powder Clean & Fresh 500g",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 500000
      },
      "tax_total": {
        "cent_amount": 38200,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 211800,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 38200,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "ef4d040b-bf9d-4109-b47f-d2e430feb8be",
      "order_line_id": "664ee088-1d2f-54d5-b9b8-3a6e71acd622",
      "sku_code": "10000704",
      "tax_code": "33049920",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vency Nail Polish Z149 6ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 740000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 780000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 40000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 740000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 40000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "9a4dd981-7738-4b7f-a1bf-01b960a4aa3a",
      "order_line_id": "032ff3d4-508d-5459-899a-2d96a3276bdd",
      "sku_code": "10000722",
      "tax_code": "34021190",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Wheel Detergent Powder Clean & Fresh 1kg",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 66500
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 70000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 3500,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 66500,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 3500,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "d5c591bf-d9ba-420d-87b7-fdeb4b229cd2",
      "order_line_id": "8fbd6c4f-13ba-5ff7-b8bd-58ab0eca367d",
      "sku_code": "10000682",
      "tax_code": "32041294",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Ujala Supreme 30ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 1230000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 1300000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 70000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 1230000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 70000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "d587f7b3-3cd7-4027-9cd9-9b878279e6a7",
      "order_line_id": "553e6f5a-1911-5930-9b0c-071ca6344a51",
      "sku_code": "10000675",
      "tax_code": "34025000",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Surf Excel Matic Liquid Top Load 500ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 378000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 420000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 42000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 378000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 42000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "1f54a27f-7e41-4d50-9b7b-c1f1b303130f",
      "order_line_id": "5a218107-7c0e-50f6-a5de-c971f2855296",
      "sku_code": "10000729",
      "tax_code": "96190010",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Whisper Choice XL 6N",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 285000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 300000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 15000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 285000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 15000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "f93a6de5-7535-4259-bcad-5df8b21f13f4",
      "order_line_id": "b0d06420-3b57-5156-8775-ccec1d351162",
      "sku_code": "10000715",
      "tax_code": "34054000",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vim Bar Lemon 300g",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 500000
      },
      "tax_total": {
        "cent_amount": 12000,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 238000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 12000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "2e13331e-18df-4941-94b6-96340aa43485",
      "order_line_id": "2e207481-e7b4-5f75-9ed9-fc9a70a38e99",
      "sku_code": "10000681",
      "tax_code": "96190090",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Tulips Paper Stick Cottton Swabs Pouch 100 Nos.",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 95000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 100000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 5000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 95000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 5000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "693a0b42-5608-43c2-b091-20489b32f37b",
      "order_line_id": "c6f8b8db-7fbf-5816-9248-4b264e044c64",
      "sku_code": "10000686",
      "tax_code": "33041000",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vaseline Pure Petroleum Jelly Original 20g",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 380000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 400000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 20000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 380000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 20000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "874d2dce-fa54-44e4-b42f-34c9a85eaf59",
      "order_line_id": "bb7f92b2-6a79-5ba6-8d8b-425ee50fa905",
      "sku_code": "10000712",
      "tax_code": "34011942",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vicks Vaporub 10ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 190000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 200000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 10000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 190000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 10000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "b0a39500-2f6b-4845-abc9-6eb6d8b16efa",
      "order_line_id": "e1f27265-30a1-5f9e-a2f7-752b38c93df4",
      "sku_code": "10000667",
      "tax_code": "34011930",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Surf Excel Bar 150g",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 330000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 350000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 20000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 330000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 20000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "db19c509-9b62-4042-994a-237a14b20e50",
      "order_line_id": "43290e45-a0ad-5cab-af03-a8cd44a26aba",
      "sku_code": "10000668",
      "tax_code": "34011930",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Surf Excel Bar 250g",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 1560000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 1640000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 80000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 1560000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 80000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "5760ff6f-0a66-48d3-a8fc-4837e2c15127",
      "order_line_id": "0a56a7c0-9a78-5b03-a612-4ef002f61f0c",
      "sku_code": "10000671",
      "tax_code": "34025000",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Surf Excel Easy Wash 1kg",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 2
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 190000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 200000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 10000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 380000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 20000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "621a3daa-ebec-4661-8105-7054dab7aa2a",
      "order_line_id": "6d886983-eda5-5bf7-b7c9-d1bfa4dc98fa",
      "sku_code": "10000674",
      "tax_code": "34025000",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Surf Excel Matic Front Load Liquid 50ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 500000
      },
      "tax_total": {
        "cent_amount": 38200,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 211800,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 38200,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "94115006-f99b-44ef-b113-71c975596eac",
      "order_line_id": "c4401ed0-0699-56e3-b0ca-8a7e354cbd87",
      "sku_code": "10000698",
      "tax_code": "33049920",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vency Nail Polish M045 6ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 500000
      },
      "tax_total": {
        "cent_amount": 38200,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 211800,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 38200,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "5c249ea6-2dcc-4477-9437-0f7f53c827dd",
      "order_line_id": "dc36d64a-0cea-5b12-acc2-026e6a4d0939",
      "sku_code": "10000706",
      "tax_code": "33049920",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vency Nail Polish Z157 6ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 250000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 500000
      },
      "tax_total": {
        "cent_amount": 38200,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 211800,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 38200,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 250000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "a34e47e5-09f3-4b73-b2db-44066f32d51c",
      "order_line_id": "371597e3-4af2-561c-ab6a-0646c4aafa34",
      "sku_code": "10000690",
      "tax_code": "33049920",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Vency Nail Polish C060 6ml",
      "has_packs": false,
      "pack": null
    },
    {
      "quantity": {
        "quantity_uom": "pcs",
        "quantity_number": 1
      },
      "unit_price": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 95000
      },
      "mrp": {
        "currency": "INR",
        "fraction": 10000,
        "cent_amount": 100000
      },
      "tax_total": {
        "cent_amount": 0,
        "fraction": 10000,
        "currency": "INR"
      },
      "discount_total": {
        "cent_amount": 5000,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 95000,
        "currency": "INR",
        "fraction": 10000
      },
      "total_tax": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "total_discount": {
        "cent_amount": 5000,
        "currency": "INR",
        "fraction": 10000
      },
      "invoice_line_id": "bc1849a3-169f-429c-9da3-6ab846fe6bbe",
      "order_line_id": "60f1d051-3d2e-5a83-ad34-58777939413e",
      "sku_code": "10000724",
      "tax_code": "34011190",
      "custom_info": null,
      "created_at": "2025-01-07T11:19:24.213164+00:00",
      "invoice_id": "be640840-c51f-4f16-80c8-1b2f6e807fdb",
      "sku_title": "Wheel Green Detergent Bar 190g",
      "has_packs": false,
      "pack": null
    }
  ],
  "tax_details": {
    "tax_lines": [
      {
        "tax_percentage": "0",
        "tax_value": "0",
        "cgst_value": "0",
        "cgst_percentage": "0",
        "sgst_value": "0",
        "sgst_percentage": "0",
        "igst_value": "0",
        "igst_percentage": "0",
        "cess_value": "0",
        "cess_percentage": "0"
      },
      {
        "tax_percentage": "5",
        "tax_value": "1.2",
        "cgst_value": "0.6",
        "cgst_percentage": "2.5",
        "sgst_value": "0.6",
        "sgst_percentage": "2.5",
        "igst_value": "0",
        "igst_percentage": "0",
        "cess_value": "0",
        "cess_percentage": "0"
      },
      {
        "tax_percentage": "18",
        "tax_value": "22.88",
        "cgst_value": "11.44",
        "cgst_percentage": "9",
        "sgst_value": "11.44",
        "sgst_percentage": "9",
        "igst_value": "0",
        "igst_percentage": "0",
        "cess_value": "0",
        "cess_percentage": "0"
      }
    ],
    "tax_totals": {
      "total_cess": "0",
      "total_cgst": "12.04",
      "total_igst": "0",
      "total_sgst": "12.04",
      "total_tax": "24.08"
    }
  },
  "payment_methods": "CASH",
  "contact_details": {
    "website": "www.ebono.com",
    "email_id": "support@ebono.com"
  },
  "terms_and_conditions": [
    "For products eligible for returns, customer should initiate the return request within 7 days from the day of receiving the products.",
    "Select categories are non-returnable like Dairy, Frozen food , etc. Refunds will be processed within 5 working days from the date of request."
  ],
  "mrp_savings": {
    "cent_amount": 2155000,
    "currency": "INR",
    "fraction": 10000
  },
  "grand_total": {
    "cent_amount": 8223800,
    "currency": "INR",
    "fraction": 10000
  },
  "mrp_total": {
    "cent_amount": 8223800,
    "currency": "INR",
    "fraction": 10000
  },
  "quantity_total": "23",
  "roundOffTotal": "823.00",
  "roundoff": "0.62"
}
''';