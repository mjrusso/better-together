# Better Together

_Better Together_ is an experimental communication framework.

The goal is to explore the merits of building applications with dynamic user interfaces that seamlessly and simultaneously span multiple devices.

This code is a companion to the BlackBerry Developer Conference 2011 session COM35, entitled *BlackBerry Amplified: Building Tablet and Smartphone Apps that Work Together*.

## Design

This communication framework enables an arbitrary number of clients to be joined together in a manner that imitates having a direct, persistent communication channel between each client.

Clients can dispatch messages, which are then forwarded to all other connected ("paired") clients. (Note that each forwarded message is modified to contain information about the sender of the original message.)

Although the goal of the project is to facilitate the formation of application user interfaces that span multiple devices simultaneously, the nature of the framework is such that it can be used for any arbitrary cross-device communication.

![system](https://github.com/mjrusso/better-together/raw/master/diagrams/better-together-bridge.png)

## Rough Draft (What's missing?)

This is a very rough draft. The concept of building UIs that concurrently span multiple devices is new territory and this project simply serves as a way to validate a few different use cases and assumptions.

Many elements of the project are unfinished. For example:

- There is no mechanism for authenticating devices during the pairing process. A proper authentication process could involve entering a secret passcode.

- Communication is not performed over a secure channel.

- Only a single pairing session is enabled per back-end. ([Socket.io][socketio]'s room functionality could be used to increase the number of simultaneous pairing sessions per back-end.)

- In the ideal case, we would not have this central back-end server at all: this device-to-device communication channel would occur over Bluetooth or an ad-hoc WiFi network. The central server adds latency and requires that each device has an Internet connection. (For the BlackBerry platform in particular, the goal is to use BlackBerry Bridge APIs or Bluetooth APIs, whenever they are made available to application developers by RIM.)

## Components

### Routing Service

The Routing Service maintains a persistent connection between each connected client via [socket.io][socketio]. Each message that is sent from a client to the Routing Service is transparently forwarded to all connected/ paired clients.

### Shell App

The Shell App is a web app that displays a running log of all of the devices that have connected, and the messages that have been sent and received via the Routing Service, etc.

### Bookmarklet

The browser bookmarklet sends a message of type `command:viewURL` to the central routing service with the URL of the current web page being viewed.

The bookmarklet can be accessed from the "Bookmarklet" link in the header bar of the Shell App.

### PlayBook App

The PlayBook App responds to messages of type `command:viewURL` by automatically opening the URL of the browser in the native PlayBook Web browser.

### Context Service

The Context Service is a prototype that will run incoming textual content through a [part-of-speech tagger][part-of-speech-tagging] ([glossary][node-glossary], in this case) and then rank each term/ phrase by relevancy (based on the number of occurrences).

The Shell App listens for messages of type `context:viewContent`, and, in response, makes a request to this Context Service. Once the Context Service returns the ranked list of terms, the Shell App makes an additional request to the [Qwiki API][qwiki-api] to automatically display content that is related to the supplied text.

![context-service](https://github.com/mjrusso/better-together/raw/master/diagrams/better-together-contextual-data-service.png)

## API Details

A JavaScript API is included for interfacing with the Routing Service.

See `./server/src/client/bridge.coffee` for API usage details.

## Usage

### Routing Service

_Perform the following commands from the `./server`_ directory.

Install dependencies via [npm][npm]:

    cake deps

Compile source (requires [CoffeeScript][coffeescript]):

    cake build

Or, watch (automatically compile when files change):

    cake watch

Run the server:

    node server.js

Note: for development, it is recommended to run the server with [node-supervisor][node-supervisor], in conjunction with `cake watch`, as this will automatically restart the server when code changes:

    supervisor -w lib,server.js server.js

_(First, you will need to install node-supervisor via npm: `npm install supervisor -g`.)_

### Shell App

Run the Routing Service (as described above) and then access the server via your Web browser. For example, if the server is running on `localhost` and the default port (`8000`), then the Shell App can be accessed at [http://localhost:8000](http://localhost:8000).

### PlayBook App

To configure, modify the `bridge_address` variable in the file `./playbook/config.erb` to point to the address of the routing service that you are running.

_Perform the following commands from the `./playbook`_ directory.

Build app:

    rake build

Deploy to PlayBook device or simulator:

    rake deploy ip=:ip-address pw=:password

Here:

- `:ip-address` is the IP address of the PlayBook being deployed to
- `:password` is the password of the PlayBook device

### Context Service

The Context Service is automatically made available when running the Routing Service.

## Acknowledgements

Server code based on [express-coffee][express-coffee] template.

[socketio]: http://socket.io
[part-of-speech-tagging]: http://en.wikipedia.org/wiki/Part-of-speech_tagging
[node-glossary]: https://github.com/harthur/glossary
[qwiki-api]: http://www.qwiki.com/api
[npm]: http://npmjs.org
[coffeescript]: http://jashkenas.github.com/coffee-script/
[node-supervisor]: https://github.com/isaacs/node-supervisor
[express-coffee]: https://github.com/twilson63/express-coffee
