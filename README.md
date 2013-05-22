# Huffer

Huffer is a setup utilizing [Grunt](http://gruntjs.com/) for rapidly developing [Ember.js](http://emberjs.com/) applications.

It makes your objects available as CommonJS across the application, comes with a build system and also (headless) testing.

## Requirements

Node.js v0.8 or higher, with npm.

You are also expected to have these modules installed globally:

    $ npm install -g grunt-cli bower coffee-script

## Installation

    $ git clone git://github.com/fahad19/huffer.git
    $ cd huffer
    $ npm install .
    $ bower install .
    $ grunt

## Usage

    $ grunt build       # builds your files under /public directory
    $ grunt server      # builds and starts a web server
    $ grunt watch       # builds files under /public as you make changes
    $ grunt live        # builds and starts a server, opens in your browser with live refreshing
    $ grunt test        # builds the application with tests
    $ grunt test-server # builds tests and starts a server
    $ grunt test-live   # builds and starts live test server, and opens in your browser with live refreshing
    $ grunt test-run    # builds and runs the tests in PhantomJS
    $ grunt clear       # deletes all build files

## Application structure

By default, Huffer comes with a few ready-to-use Ember.js objects that should start your application just fine without requiring you to have any knowledge for the framework. But you are advised to [read the official documentation](http://emberjs.com/guides/) if you wish to go any further.

Huffer has all its objects available as CommonJS as they are stitched together, and can be `require()`d from anywhere.

For example, the file at `lib/my_custom_lib.coffee` (or .js) can be required in your application by doing:

    var myCustomLib = require('lib/my_custom_lib');

All your application code is expected to go under `/app` directory.

* app/
    * config/
        * bootstrap.coffee
        * routes.coffee
    * controllers/
    * helpers/
    * lib/
    * routes/
    * templates

### config

`config` directory has your application bootstrap and defined routes. The bootstrap file is the entry point of your application and everything starts here.

### controllers

It is always best to refer to original Ember.js documentation to learn about its objects. But in short, controller properties are made available to your templates that you can use later.

### helpers

Helpers are [Handlebars](http://handlebarsjs.com/) helpers that you can use in your templates. They are not objects that you can `require()` yourself, but rather just defined.

### lib

This is where custom libraries go. Huffer comes with its own `Loader` class that makes sure that all you objects are assigned to Ember.js app at `window.App` automatically.

### routes

All your Ember.js route objects go here.

### templates

All your handlebars templates go here, and they should have `.handlebars` extension.

The `Loader` class of Huffer makes sure that all the templates are available in `window.Ember.TEMPLATES`.

## Conventions

For ease of development, it is expected to follow some naming conventions.

Examples:

* Controller file should be at `/app/controllers/posts_controller.js` for `win.App.PostsController`.
* Route file should be at `/app/routes/posts_route.js` for `window.App.PostsRoute`
* Template file should be at `/app/templates/pages/about.handlebars` for `window.Ember.TEMPLATES['pages/about']`

Following these naming convention then makes it possible for Huffer's Loader to be able to go through the available modules and assign them to `window.App` during bootstrapping.

## Themes

Huffer comes with its own `default` theme, which you can find at `/themes/default`. It uses [Twitter Bootstrap](twitter.github.com/bootstrap/).

At the moment, Huffer expects your CSS to be written in LESS only, mainly to support Twitter Bootstrap.

It expects your theme to have a minimum structure like this:

* themes/your_theme_name/
    * css/
        * theme.less
    * layouts/
        * index.html

It is always best to copy the default theme and then modify it if you are developing your own first theme.

## Vendors

Huffer uses [Bower](http://bower.io/) for installing all external libraries like jQuery and Ember.js. They are all set in `bower.json` file, and downloaded to `/public/vendors` directory.

If you wish to add more, modify the JSON file, and do:

    $ bower install .

## Configuration

There are some basic configuration values that you can set for your application, which you can do in `config.js` file.

## Testing

Huffer uses [Mocha](http://visionmedia.github.io/mocha/) in combnation with [expect.js](https://github.com/LearnBoost/expect.js/) for testing.

If you wish to perform headless testing, you are required to have [PhantomJS](http://phantomjs.org/) available globally. To install, do:

    $ brew install phantomjs

Now you can run your tests from the Terminal:

    $ grunt test-run

## License

It is released under the MIT License.
