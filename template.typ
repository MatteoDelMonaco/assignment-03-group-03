#let template(
  title: "",
  author: "",
  print: false,
  slides: true,
  contents: true,
  doc,
) = {
  // PALETTE
  let page-color = if print {
    white
  } else {
    rgb("#F5EEDC")
  }

  let page-format = if slides {
    "presentation-16-9"
  } else {
    "a4"
  }

  let quote-color = page-color.darken(5%)
  let quote-mark-color = page-color.darken(70%)
  let text-color = page-color.darken(95%)

  set heading(numbering: "1.")

  show link: it => {
    set text(fill: rgb("#0645AD"))
    underline(it)
  }

  set page(
    paper: page-format,
    margin: (x: 10%, y: 10%),
    //    paper: "a4",
    //    margin: (x:1.8cm, y:1.5cm),
    fill: page-color,

    header: context {
      let current-page = here().page()

      let chapters = query(heading.where(level: 1)).filter(it => it.location().page() <= current-page)

      if chapters != () and chapters.last().location().page() != current-page {
        text(
          size: 8pt,
          style: "italic",
          fill: page-color.darken(50%),
        )[
          #align(center)[
            #chapters.last().body
          ]
        ]
      }
    },
  )
  set text(
    font: "Libertinus Serif",
    size: 13pt,
    fill: text-color,
  )

  set par(
    justify: true,
    leading: 0.52em,
  )

  let first = state("first-heading", true)

  show heading.where(level: 1): it => {
    if first.get() {
      first.update(false)
      [
        #v(2cm)
        #it
      ]
    } else {
      [
        #pagebreak()
        #v(1.5cm)
        #align(center)[
          #text(size: 20pt)[#it]
        ]
        #v(1.5cm)
      ]
    }
  }

  show heading: it => {
    if it.level != 1 {
      [
        #it
        #v(-.5em)
        #line(length: 100%)
        #v(.5em)
      ]
    } else {
      it
    }
  }

  show image: it => align(center)[#it]

  set quote(block: true)

  show quote: it => {
    align(center)[
      #block(
        fill: quote-color,
        inset: 1em,
        width: 80%,
        breakable: false,
      )[
        #grid(
          columns: (auto, 1fr),
          gutter: 0.8em,
          [
            #text(
              size: 36pt,
              fill: quote-mark-color,
            )[
              "
            ]
          ],
          [
            #set align(left)
            #set text(
              size: 13pt,
              fill: quote-mark-color,
            )
            #it
          ],
        )
      ]
    ]
  }

  // Title page
  align(center)[
    #v(40%)

    #text(size: 30pt)[
      *#title*
    ]

    #text(
      style: "italic",
      size: 15pt,
    )[
      Written by:
      #v(1%)
      \~ #author \~
    ]

  ]

  pagebreak()

  if (contents) {
    outline()
  }

  counter(page).update(1)

  set page(
    numbering: "- 1 -",
  )

  doc
}


