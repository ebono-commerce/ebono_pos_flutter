const jsonData = '''
{
  "outlet_address": {
    "name": "EBONO Electronic City 01",
    "full_address": "No 40, Alfa Garden Entrance,\\nKodigehalli Main Road,\\nKR Puram,\\nBengaluru-560049",
    "phone_number": {
      "country_code": "91",
      "number": "9380919234"
    },
    "gstin_number": "29AAECK6393H1Z2"
  },
  "invoice_number": "#12345678",
  "invoice_date": "23/12/2024",
  "order_number": "1234567",
  "order_date": "23/12/2024, 12:00 PM",
  "payment_methods": "wallet, Cash",
  "customer": {
    "customer_name": "Jagath Ratchagan",
    "phone_number": {
      "country_code": "+91",
      "number": "9597135456"
    }
  },
  "invoice_lines": [
    {
      "sku_code": "1006885062",
      "sku_title": "Aashirvaad Shudh Chakki Atta, 10kg Pack",
      "quantity": {
        "quantity_number": "1",
        "quantity_uom": "pcs"
      },
      "unit_price": {
        "cent_amount": 1000000,
        "currency": "INR",
        "fraction": 10000
      },
      "mrp": {
        "cent_amount": 10000000,
        "currency": "INR",
        "fraction": 10000
      },
      "discount_total": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "tax_total": {
        "cent_amount": 0,
        "currency": "INR",
        "fraction": 10000
      },
      "grand_total": {
        "cent_amount": 1000000,
        "currency": "INR",
        "fraction": 10000
      }
    }
  ],
  "tax_details": {
    "taxes_lines": [
      {
        "tax_percentage": "9",
        "tax_value": "102.05",
        "cgst_value": "52.10",
        "cgst_percentage": "9",
        "sgst_value": "52.10",
        "sgst_percentage": "9",
        "igst_value": "0.0",
        "igst_percentage": "",
        "cess_value": "0.0",
        "cess_percentage": "0"
      }
    ],
    "taxes_totals": {
      "total_tax": "467",
      "total_cgst": "467",
      "total_sgst": "467",
      "total_igst": "467",
      "total_cess": "467"
    }
  },
  "totals_in_words": "Six hundred Sixty nine Rupees Only",
  "grand_total": {
    "cent_amount": 0,
    "currency": "INR",
    "fraction": 10000
  },
  "mrp_savings": {
    "cent_amount": 0,
    "currency": "INR",
    "fraction": 10000
  },
  "discount_total": {
    "cent_amount": 0,
    "currency": "INR",
    "fraction": 10000
  },
  "tax_total": {
    "cent_amount": 0,
    "currency": "INR",
    "fraction": 10000
  },
  "contact_details": {
    "website": "www.ebono.com",
    "email_id": "support@ebono.com"
  },
  "terms_and_conditions": [
    "For products eligible for returns, customer should initiate the return request within 7 days from the day of receiving the products.",
    "Select categories are non-returnable like Dairy, Frozen food , etc. Refunds will be processed within 5 working days from the date of request."
  ]
}
''';