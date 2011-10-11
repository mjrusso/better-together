glossary = (require 'glossary') verbose: true

module.exports = (app) ->

  app.post '/context/keywords', (request, response) ->
    title = request.body.title
    text = request.body.text.replace /<.*?>/g, ''

    # assign an extra multiplier (2x) to terms in the title
    document = title + title + text

    keywords = glossary.extract document

    keywords.sort (a, b) ->
      if a.count < b.count then 1
      else if a.count > b.count then -1
      else 0

    response.send keywords
