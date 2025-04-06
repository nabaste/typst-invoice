#import "\lib.typ": invoice

#show: invoice(
  // Invoice number
  "2025-003",
  // Invoice date
  datetime(year: 2025, month: 04, day: 07),
  // Items
  (
    (
      description: "Mixed Reality Unity Development",
      price: 500,
    ),
  ),
  // Author
  (
    name: "Nahuel Basterretche",
    street: "2 Lodge Mansions Parade",
    zip: "N13 5TS",
    city: "London",
    tax_nr: "12345/67890",
    // optional signature, can be omitted
    signature: image("Signature2b.png", width: 5em)
  ),
  // Recipient
  (
    name: "Hyperactive Developments",
    street: "415 High Street Suite 111",
    zip: "E15 4QZ",
    city: "London",
  ),
  // Bank account
  (
    name: "Nahuel Arnaldo Basterretche",
    bank: "Wise Payments Ltd.",
    iban: "GB66TRWI23147050822066",
    bic: "50822066",
    sort: "23-14-70",
    // There is currently only one gendered term in this template.
    // You can overwrite it, or omit it and just choose the default.
    gender: (account_holder: "Account Holder")
  ),
  // Umsatzsteuersatz (VAT)
  vat: 0.19,
  kleinunternehmer: true,
)

