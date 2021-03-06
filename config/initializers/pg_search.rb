# frozen_string_literal: true

PgSearch.multisearch_options = {
  ignoring: :accents,
  using: {
    tsearch: {
      dictionary: 'english',
      prefix: true,
      any_word: true,
      highlight: {
        StartSel: '<mark>',
        StopSel: '</mark>'
      }
    }
  }
}
