# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

* Add redis, bootstrap-sass, jquery-rails and simple_form gmes to Gemfile

* Require Bootstrap JS assests/javascripts/application.js

```ruby
//= require jquery
//= require bootstrap-sprockets
```

* Import Bootstrap styles in assets/stylesheets/application.scss
```ruby
// "bootstrap-sprockets" must be imported before "bootstrap" and "bootstrap/variables"
@import "bootstrap-sprockets";
@import "bootstrap";	
```

* Run the generator for simple_form and integrated to the Bootstrap
```html
rails generate simple_form:install --bootstrap
```

* Running standalone cable servers: Action cable can run alongside your rails app. For example, to listen for WebSocket requests on /websocket, specify that path to config.action_cable.mount_path:

```ruby
# config/application.rb
config.action_cable.mount_path = '/websocket'
```

* modify layout\application.html.erb to add action_cable_meta_tag

```ruby
<%= action_cable_meta_tag %>
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
```

* modify assests/javascript/cable.js to add meta tag of action_cable_meta_tag

```javascript
App.cable = ActionCable.createConsumer($('meta[name=action-cable-url]').attr('content'));
```

* Generate message model

```html
rails g model message user:string content:text

rake db:create && rake db:migrate
```

* Generate Visitors Controller

```html
rails g controller visitors chat
```

* modify config/routes.rb

```ruby
	get :chat, to: 'visitors#chat'
	root to: 'visitors#chat'
```



