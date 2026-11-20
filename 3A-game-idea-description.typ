#import "template.typ": template
#import "patterns.typ": setup

#show: setup

#show: template.with(
  title: "",
  author: "",
  print: false,
  slides: false,
  contents: true,
)


#pagebreak()
#bibliography("references.bib")

