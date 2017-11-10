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
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
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

* Add html content to views/visitors/chat.html.erb


* modify config/routes.rb

```ruby
	get :chat, to: 'visitors#chat'
	root to: 'visitors#chat'
```

* Generate chat channel

```ruby
rails g channel chat
```


#### Workflow of action cable
```ruby
1. When message is created then we want to broadcase the message to all users

rails g channel chat
	chat_channel.rb will be the server side process of your channel
	chat.coffee: content client side handler to handle the message

2. When user submitted the message, it will post to messages#create method to create the message

	when user subscribed the "chat" channel, it will become a listenner of any kind of publish to that channel, in our case is a new message

3. In our Message controller, we creating a new message of the params[:message].permit!
	Then calling ActionCable.server.broadcase, then passing a hash and calling a render	
	squish function is take the render object into one line and remove spaces.

4. Then the ActionCable.server.broadcase will call the received: function on the client side, this will take data hash we just recieved, then we will prepend to the message.

5. We don't want to have Controller to call the ActionCable, we will create a after_create_commit callback to call the backgroud job to render the message.

	- we will comment out the the ActionCable.server.broadcase from the MessagesController.rb
	# controllers/messages_controller.rb
	def create
		message = Message.create(params[:message].permit!)
		# ActionCable.server.broadcast "chat", {
		# 	message: MessagesController.render(
		# 		partial: 'message',
		# 		locals: {message: message}
		# 	).squish
		# }		
	end

	- we will create a after_create_commit call back in the Message model
	# models/message.rb

	after_create_commit{
			ActionCable.server.broadcast "chat", {
				message: MessagesController.render(
					partial: 'message',
					locals: {message: message}
				).squish
			}	
	}

	BUT this could create a delay for the user of which is for render which is for broadcase.
	We want to move this to a background job.

	rails g job message_broadcast

	#jobs/messages_broadcast_job.rb
	def perform(message) #*args
    # Do something later
    ActionCable.server.broadcast "chat", {message: render_message(message)}
  end

  def render_message(message)
  	MessagesController.render(partial: 'message', locals: {message: message}).squish
  end

```




























