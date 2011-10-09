bookmarkletURL = "http://192.168.1.109:8000/bookmarklet.js"

doctype 5
html ->
  head ->
    title 'Better Together'
    meta charset: 'utf-8'

    link rel: 'icon', href: '/favicon.png'
    link rel: 'stylesheet', href: '/bootstrap.css'
    link rel: 'stylesheet', href: '/app.css'

    script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js'
    script src: '/socket.io/socket.io.js'
    script src: '/bridge.js'
    script src: '/app.js'

    coffeescript ->
      $(document).ready ->
        console.log 'dom ready'

  body ->

    div class: 'topbar', ->
      div class: 'fill', ->
        div class: 'container', ->
          a class: 'brand', href: '#', ->
            "Better Together"
          ul class: 'nav', ->
            li class: 'active', ->
              a href: '#', ->
                'Home'
            li ->
              a href: '#', id: 'send-message', ->
                'Send Message'
            li ->
              a href: "javascript:(function(){var d=document,bt=d.getElementById('better-together');if(bt){return;}var s=d.createElement('script');s.src='#{bookmarkletURL}';d.body.appendChild(s)})()", ->
                'Bookmarklet'

    div class: 'container', ->

      div class: 'row', ->
        div class: 'span10', ->
          div "main content", ->
            div id: 'main-content', ->

        div class: 'span4', ->
          h3 "Secondary content", ->
            div id: 'activity-stream', ->
              ul ->
