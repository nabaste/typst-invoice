#import "@preview/cades:0.3.0": qr-code
#import "@preview/ibanator:0.1.0": iban

// Generates an invoice
#let invoice(
  // The invoice number
  invoice-nr,
  // The date on which the invoice was created
  invoice-date,
  // A list of items
  items,
  // Name and postal address of the author
  author,
  // Name and postal address of the recipient
  recipient,
  // Name and bank account details of the entity receiving the money
  bank-account,
  // The text to display below the items
  invoice-text: "Thank you for your cooperation. Please transfer the invoice amount
within 14 days without deductions to my account below, stating
the invoice number.",
  // Optional VAT
  vat: 0.19,
  // Check if the german § 19 UStG applies
  kleinunternehmer: false,
) = {
  set text(lang: "en", region: "UK")

  set page(paper: "a4", margin: (x: 20%, y: 20%, top: 20%, bottom: 20%))

  // Typst can't format numbers yet, so we use this from here:
  // https://github.com/typst/typst/issues/180#issuecomment-1484069775
  let format_currency(number, locale: "de") = {
    let precision = 2
    assert(precision > 0)
    let s = str(calc.round(number, digits: precision))
    let after_dot = s.find(regex("\..*"))
    if after_dot == none {
      s = s + "."
      after_dot = "."
    }
    for i in range(precision - after_dot.len() + 1){
      s = s + "0"
    }
    // fake de locale
    if locale == "de" {
      s.replace(".", ",")
    } else {
      s
    }
  }

  set text(number-type: "old-style")

  smallcaps[
    *#author.name* •
    #author.street •
    #author.zip #author.city
  ]

  v(1em)

  [
    #set par(leading: 0.40em)
    #set text(size: 1.2em)
    #recipient.name \
    #recipient.street \
    #recipient.zip
    #recipient.city
  ]

  v(4em)

  grid(columns: (1fr, 1fr), align: bottom, heading[
    Invoice \##invoice-nr
  ], [
    #set align(right)
    #author.city, *#invoice-date.display("[day].[month].[year]")*
  ])

  let total = items.map((item) => item.price).sum()

  let items = items.enumerate().map(
    ((id, item)) => ([#str(id + 1).], [#item.description], [#format_currency(item.price)€],),
  ).flatten()

  [
    #set text(number-type: "lining")
    #table(
      stroke: none,
      columns: (auto, 10fr, auto),
      align: ((column, row) => if column == 1 { left } else { right }),
      table.hline(stroke: (thickness: 0.5pt)),
      [*Num.*], [*Description*], [*Cost*],
      table.hline(),
      ..items, table.hline(),
      [],
      [
        #set align(end)
        Summe:
      ],
      [#format_currency(if kleinunternehmer {total} else {(1.0 - vat) * total})€],
      table.hline(start: 2),
      ..if not kleinunternehmer {(
        [],
        [
          #set text(number-type: "old-style")
          #set align(end)
          #str(vat * 100)% Mehrwertsteuer:
        ],
        [#format_currency(vat * total)€],
        table.hline(start: 2),
        [],
      )} else {([], [], [], [])},
      [
        #set align(end)
        *Total:*
      ],
      [*#format_currency(total)£*],
      table.hline(start: 2),
    )
  ]

  v(2em)

  // [
  //   #set text(size: 0.8em)
  //   #invoice-text
  //   #if kleinunternehmer [
  //     Gemäß § 19 UStG wird keine Umsatzsteuer berechnet.
  //   ]
  // ]

  v(1em)

  // This is the content of an https://en.wikipedia.org/wiki/EPC_QR_code version 002
  // Eventually this could be put into its own package?
  let epc-qr-content = (
    "BCD\n" + "002\n" + "1\n" + "SCT\n" + bank-account.bic + "\n" + bank-account.name + "\n" + bank-account.iban + "\n" + "EUR" + format_currency(total, locale: "en") + "\n" + "\n" + invoice-nr + "\n" + "\n" + "\n"
  )

  grid(columns: (1fr, 1fr), gutter: 1em, align: top, [
    #set par(leading: 0.40em)
    #set text(number-type: "lining")
    #(bank-account
      .at("gender", default: (:))
      .at("account_holder", default: "Account Holder")): #bank-account.name \
    Bank: #bank-account.bank \
    Sort Code: *#iban(bank-account.iban)* \
    Account Number: #bank-account.bic
  ], qr-code(epc-qr-content, height: 4em))

  [
    Tax Number: #author.tax_nr

    #v(0.5em)

    Best regards

    #if "signature" in author [
      #scale(origin: left, x: 400%, y: 400%, author.signature)
    ] else [
      #v(1em)
    ]

    #author.name
  ]
}
