body = document.getElementsByTagName('body')[0]

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
      iframe.style.visibility = 'hidden'
      console.log 'response: ', iframe.contentWindow.document.body;

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

hiddenFormPost "/message/viewURL",
  data: [window.location.href]
  type: 'command'
  source: 'browser'
