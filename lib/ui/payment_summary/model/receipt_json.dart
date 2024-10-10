const jsonData = '''
{
    "invoice_number": "IN002/24/0000342",
    "order_type": "B2C",
    "payment_mode": "CASH",
    "order_number": "100006709",
    "seller_address": "EBONO Pvt Ltd\\nMarathahalli - Sarjapur Rd -\\nST002, Yamare Village,\\nSarjapur, Bengaluru,\\nKarnataka, Near Prestige City,\\nIndia, 562125\\n Phone Number : 9980687569\\nGSTIN : 29AAGCE1517R1Z5\\nState Code : 29\\n",
    "billing_address": "Jagath Ratchagan\\nSy No 54 and 55/1, Yamare\\nVillage, Dommasandara,\\nSarjapura Hobli, Anekal Taluk,\\nBangalore Urban Dist, KA,\\nIndia, 562125\\n Phone Number : 9916727837\\nGSTIN : UNREGISTERED\\nState Code : 29\\n",
    "customer_name": "Jagath Ratchagan",
    "ship_address": "Jagath Ratchagan\\nSy No 54 and 55/1, Yamare\\nVillage, Dommasandara,\\nSarjapura Hobli, Anekal Taluk,\\nBangalore Urban Dist, KA,\\nIndia, 562125\\n Phone Number : 9916727837\\nGSTIN : UNREGISTERED\\nState Code : 29\\n",
    "do_number": "1705553385171",
    "order_date": "18-Jan-2024",
    "invoice_date": "18-Jan-2024 10:23:59",
    "price_info": {
        "item_total": 14285.72,
        "disc_total": 0,
        "taxable_amount_total": 14285.72,
        "tax_total": 714.28,
        "total_invoice_amount": "15,000.00",
        "in_words": "Fifteen Thousand  Rupees Only",
        "total_savings": 0,
        "cgst_total": 0,
        "sgst_total": 0,
        "igst_total": 714.29,
        "cess_total": 0
    },
    "associate_name": "",
    "associate_number": "",
    "terms_and_conditions": {
        "T&C": [
            "For products eligible for returns, customer should initiate the return request within 7 days from the day of receiving the product.",
            "Select categories are non-returnable like Tiles, Laminates & Veneer, Gypsum Board, Tanks, Sanitaryware etc.",
            "Refunds will be processed within 5 working days from the date of request.",
            "IBO is not responsible for product warranties and we recommend customers to contact the brand directly for warranty related queries.",
            "IBO does not do the product installations and we recommend customers to contact the brand directly for installation."
        ]
    },
    "invoice_lines_details": [
        {
            "description": "Dawat basmati rice 1kg Dawat basmati rice 1kg | Product Code: 1000520028  |  HSN: 62071920",
            "offer_id": "1000520028",
            "hsn_code": "62071920",
            "qty": "15",
            "uom": "Box",
            "unit_rate": "952.38",
            "unit_total_amount": "14,285.72",
            "unit_total_discount": "0.00",
            "unit_taxable_amount": "14,285.72",
            "unit_total_tax_rate": "5.0",
            "unit_total_tax": "714.28",
            "unit_line_total": "15,000.00"
        },
        {
            "description": "Dawat basmati rice 1kg Dawat basmati rice 1kg | Product Code: 1000520028  |  HSN: 62071920",
            "offer_id": "1000520028",
            "hsn_code": "62071920",
            "qty": "15",
            "uom": "Box",
            "unit_rate": "952.38",
            "unit_total_amount": "14,285.72",
            "unit_total_discount": "0.00",
            "unit_taxable_amount": "14,285.72",
            "unit_total_tax_rate": "5.0",
            "unit_total_tax": "714.28",
            "unit_line_total": "15,000.00"
        }
    ],
    "invoice_tax_list": [
        {
            "cess_rate": "0",
            "cess_amt": "0",
            "total_tax_value": "714.29",
            "cgstamt": "0",
            "sgstamt": "0",
            "igstamt": "714.29",
            "cgstrate": "0",
            "igstrate": "5.0",
            "sgstrate": "0",
            "hsncode": "62071920"
        }
    ],
    "place_of_supply": "Karnataka",
    "is_validated_at_gate": true
}
''';