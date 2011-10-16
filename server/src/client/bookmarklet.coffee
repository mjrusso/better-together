body = document.getElementsByTagName('body')[0]
serverURL = "http://192.168.1.109:8000"

# Utility function for creating a new element and setting initial properties
# from: https://github.com/barberboy/css-terminal
newElement = (tagname, properties) ->
  el = document.createElement tagname
  el[name] = value for name, value of properties
  return el

# Utility function for creating and submitting a hidden form element
hiddenFormPost = (path, params) ->

  iframe = document.getElementById('hidden-iframe')
  iframe = iframe or newElement 'iframe'
    name: 'hidden-iframe'
    id: 'hidden-iframe'
    onload: ->
      # note: `iframe.contentWindow.document.body` contains the response body
      iframe.style.visibility = 'hidden'

  body.appendChild iframe

  form = newElement 'form'
    method: 'post'
    action: path
    target: 'hidden-iframe'

  for key of params
    form.appendChild newElement 'input',
      type: 'hidden'
      name: key
      value: params[key]

  body.appendChild form
  form.submit()

hiddenFormPost "{serverURL}/message/command:viewURL",
  params: [window.location.href]
  source: 'browser'
  device: JSON.stringify
    ua: navigator.userAgent
    platform: navigator.platform
