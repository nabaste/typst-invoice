#import "\lib.typ": invoice

#show: invoice(
  // Invoice number
  "2025-003",
  // Invoice date
  datetime(year: 2025, month: 03, day: 03),
  // Items
  (
    (
      description: "Unreal Engine UI Development",
      price: 2000,
    ),
    (
      description: "Interface Design Consultation",
      price: 500
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
    name: "Territory Studio",
    street: "132-140 Goswell Road, Clerkenwell",
    zip: "EC1V 7DY",
    city: "London",
  ),
  // Bank account
  (
    name: "Nahuel Basterretche",
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

