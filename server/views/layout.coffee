bookmarkletURL = "/bookmarklet.js"

doctype 5
html ->
  head ->
    title 'Better Together'
    meta charset: 'utf-8'

    link rel: 'icon', href: '/favicon.png'
    link rel: 'stylesheet', href: '/app.css'

    script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js'
    script src: '/socket.io/socket.io.js'
    script src: '/app.js'

    coffeescript ->
      $(document).ready ->
        console.log 'dom ready'

  body ->
      header ->
        a href: '/', title: 'Home', -> 'Home'

        nav ->
          ul ->
            for item in ['A', 'B', 'C']
              li -> a href: "/#{item.toLowerCase()}", title: item, -> item

      div id: 'content', ->
        @body

      div id: 'send-message', ->
        'Send Message'

      div id: 'bookmarklet',
        a href: "javascript:(function(){var d=document,bt=d.getElementById('better-together');if(bt){return;}var s=d.createElement('script');s.src='#{bookmarkletURL}';d.body.appendChild(s)})()", ->
          "Bookmarklet"

      footer ->
        p ->
          i ->
            "it's better together"
