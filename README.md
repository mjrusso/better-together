# Better Together

An experiment in connecting multiple devices together...

Built to complement DevCon session (add more details)

## Components

### Server

change into server directory:

    cd server

install deps:

    cake deps

build:

    cake build

watch (automatically compile when files change):

    cake watch

run:

    node server.js

note: recommend using [node-supervisor][node-supervisor], in conjunction with watch:

    supervisor -w lib,server.js server.js

_(First, you will need to install node-supervisor via npm: `npm install supervisor -g`.)_

### PlayBook App

Simple app that listens for message of type `command:viewURL` (note: make sure to describe message types, above...) and, in response, opens these URLs in the built-in PlayBook browser.

Modify `bridge_address` variable in the file `./playbook/config.erb` to point to your bridge server.

build:

    rake build

deploy to PlayBook:

    rake deploy

## Acknowledgements

Server code based on [express-coffee][express-coffee] template.

[node-supervisor]: https://github.com/isaacs/node-supervisor
[express-coffee]: https://github.com/twilson63/express-coffee