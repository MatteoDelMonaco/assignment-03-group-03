
#let wiki = "https://gdp.cse.chalmers.se/index.php?title="

#let define(body, singular: none, tags: (), custom: false, url: none) = (
  body: body,
  singular: singular,
  tags: tags,
  custom: custom,
  url: if url == none { wiki + body.replace(" ", "_") } else { url },
)

#let patterns = (
  main-goals: define("Main Goals", singular: "Main Goal", tags: ("M",)),
  optional-goals: define("Optional Goals", singular: "Optional Goal", tags: ("M",)),
  dice: define("Dice", singular: "Die", tags: ("M",)),
  cards: define("Cards", singular: "Card", tags: ("M",)),
  tiles: define("Tiles", singular: "Tile", tags: ("M",)),
  tokens: define("Tokens", singular: "Token", tags: ("M",), custom: true),
  token-placement: define("Token Placement", singular: "Token Placement", tags: ("M",), custom: false),
  decks: define("Decks", singular: "Deck", tags: ("M",)),
  hands: define("Hands", singular: "Hand", tags: ("M",)),
  game-boards: define("Game Boards", singular: "Game Board", tags: ("M",)),
  scores: define("Scores", singular: "Score", tags: ("M",)),

  resources: define("Resources", singular: "Resource", tags: ("M",)),
  resource-caps: define("Resource Caps", singular: "Resource Cap", tags: ("M",)),
  collecting: define("Collecting", tags: ("M",)),

  randomness: define("Randomness", tags: ("M",)),
  secret-resources: define("Secret Resources", singular: "Secret Resource", tags: ("M", "D")),
  renewable-resources: define("Renewable Resources", singular: "Renewable Resource", tags: ("M",)),
  resource-sources: define("Resource Sources", singular: "Resource Source", tags: ("M",)),
  resource-competition: define("Resource Competition", tags: ("M",)),
  trading: define("Trading", singular: "Trade", tags: ("MD",)),
  game-element-trading: define("Game Element Trading"),
  drawing-stacks: define("Drawing Stacks", singular: "Drawing Stack", tags: ("M",)),
  sets: define("Sets", singular: "Set", tags: ("M",)),
  construction: define("Construction", singular: "Construct", tags: ("M",)),
  limited-resources: define("Limited Resources", singular: "Limited Resource", tags: ("M",), custom: true, url: ""),
  upgrades: define("Upgrades", singular: "Upgrade", tags: ("M",)),
  expansion: define("Expansion", tags: ("M",)),
  territories: define("Territories", singular: "Territory", tags: ("M",)),
  investments: define("Investments", singular: "Investment", tags: ("M",)),

  tactical-planning: define("Tactical Planning", tags: ("D",)),
  increasing-rewards: define("Increasing Rewards", singular: "Increasing Reward", tags: ("D",)),
  positive-feedback-loops: define("Positive Feedback Loops", singular: "Positive Feedback Loop", tags: ("D",)),
  negative-feedback-loops: define("Negative Feedback Loops", singular: "Negative Feedback Loop", tags: ("D",)),
  resource-management: define("Resource Management", tags: ("D",)),
  kingmaker: define("Kingmaker", tags: ("D",)),
  beat-the-leader: define("Beat the Leader", tags: ("D",)),

  turn-taking: define("Turn Taking"),

  freedom-of-choice: define("Freedom of Choice", tags: ("A",)),
  luck: define("Luck", tags: ("A",)),
  winning-by-ending-gameplay: define("Winning by Ending Gameplay"),
  penalties: define("Penalties", singular: "Penalty"),

  stimulated-planning: define("Stimulated Planning", tags: ("A",)),
  analysis-paralysis: define("Analysis Paralysis", tags: ("A",)),
  competition: define("Competition", tags: ("A",), custom: true),
  achievement: define("Achievement", tags: ("A",), custom: true),
)


// Convert a display name into its reference key.
#let to-key(body) = lower(body).replace(" ", "-")

// Find a pattern by its singular reference.
// Returns (canonical-key, pattern), or none.
#let find-singular(key) = (
  patterns
    .pairs()
    .find(
      pair => pair.at(1).singular != none and to-key(pair.at(1).singular) == key,
    )
)


// Track occurrences using the canonical plural key.
#let seen-patterns = state("seen-patterns", ())

#let render(key, pattern, singular: false) = {
  seen-patterns.update(old => old + (key,))

  context {
    let first = seen-patterns.get().filter(k => k == key).len() == 1

    let body = if singular and pattern.singular != none {
      pattern.singular
    } else {
      pattern.body
    }

    let output = if pattern.custom {
      underline(body)
    } else {
      upper(body)
    }

    [#output#if pattern.tags.len() > 0 {
        super(pattern.tags.join())
      } else {
        super[#text(fill: color.red)[??]]
      }#if first and not pattern.custom {
        cite(label(key))
      }]
  }
}


// Direct usage: #pattern("cards") or #pattern("card")
#let pattern(key) = {
  if key in patterns {
    render(key, patterns.at(key))
  } else {
    let match = find-singular(key)

    if match != none {
      render(match.at(0), match.at(1), singular: true)
    } else {
      panic("Unknown pattern: " + key)
    }
  }
}


// Reference usage: @cards or @card
#let setup(body) = {
  show ref: it => {
    let key = str(it.target)

    if key in patterns {
      render(key, patterns.at(key))
    } else {
      let match = find-singular(key)

      if match != none {
        render(match.at(0), match.at(1), singular: true)
      } else {
        it
      }
    }
  }

  body
}

