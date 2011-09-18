# Better Together

An experiment in connecting multiple devices together...

## Components

### Server

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

## Acknowledgements

Server code based on [express-coffee][express-coffee] template.

[node-supervisor]: https://github.com/isaacs/node-supervisor
[express-coffee]: https://github.com/twilson63/express-coffee