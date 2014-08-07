Template.searchform.events 
	'click #search': (e,t) ->
		e.preventDefault()
		Session.set 'project', $('#searchKey').val()?.trim()

project = ->  Session.get 'project' #$('#searchKey').val()?.trim()

Template.wlist.visible = ->
	Meteor.user()?.username in ['J.K', 'yuki'] #this is not safe
Template.wlist.jk = ->
	Meteor.user()?.username is 'J.K' #not safe

Template.wlist.events
	'click #addUser':(e,t) ->
		unless (username = t.find('#username').value?.trim())?
			return
		else	
			Meteor.call "addUser", Meteor.user().username, username
			$('#username').val('').select().focus()
			e.preventDefault()
			#console.log this, username
	'click #removeUser':(e,t) ->
		unless (username = t.find('#username').value?.trim())?
			return
		else	
			Meteor.call "removeUser", Meteor.user().username, username
			$('#username').val('').select().focus()
			e.preventDefault()
			#console.log this, username

Template.printing.notClean = -> 'off'#true
Template.printing.rendered = ->
	Deps.autorun ->
		Meteor.subscribe "posts", Meteor.user()?.username
		Meteor.subscribe "comments", Meteor.user()?.username, @_id


Template.posts.rendered = ->
	Deps.autorun ->
		Meteor.subscribe "posts", Meteor.user()?.username
		#Meteor.subscribe "likes"
		#Meteor.subscribe "appusers", Meteor.userId()
		Meteor.subscribe "comments", Meteor.user()?.username, @_id

Template.posts.posts = ->
	return [] until project()
	Posts.find {parent:null, project: project()}, 
		sort: date: 1 #lastCommentDate:-1	


Template.total.helpers
	project: ->
		project()

	totalPrice: ->
		return 'Set Project First' until project()
		suma (Posts.find {parent:null, project: project()}).fetch()

	visible: ->
		Session.get 'newItem'

Template.total.events
	'click #add': (e,t)->
		Session.set 'newItem', not Session.get 'newItem'

Template.post.helpers
	editing: -> (Session.get 'editing') is @_id
	
	visible: ->
		Session.get "newComment#{@_id}" 
###
	price: ->
		@getPrice() #@price ? suma (Posts.find parent: @_id).fetch()
###
Template.post.events
	'click #add': (e,t) ->
		Session.set "newComment#{@_id}", not Session.get "newComment#{@_id}"
	'click #edit': (e,t)->
		Session.set "editing", @_id	

	'click #checked': (e,t)->
		isChecked = not @checked
		Meteor.call "isChecked", @_id, isChecked

	'click #remove': (e,t)->
		Meteor.call 'removePost', @_id

###Template.commentsList.rendered = ->
	Deps.autorun ->
		#Meteor.subscribe "posts", Meteor.user()?.username
		#Meteor.subscribe "post", Meteor.user()?.username, @_id
		#Meteor.subscribe "comments", Meteor.user()?.username, @_id
###	
	

Template.commentsList.comments = ->
	Posts.find parent: @_id,
		sort: date: 1

Template.comment.helpers
	editing: -> (Session.get 'editing') is @_id

Template.itemView.events
	'click #add': (e,t)->
		Session.set "editing", @_id	

	'dblclick #remove': (e,t)->
		Meteor.call 'removePost', @_id

	
AutoForm.addHooks ['updatePostForm'],
	after:
		update: (error)->
			if error
				console.log "Update Error:", error
			else
				#console.log "Updated!"
			Session.set "editing", null

Template.new.helpers
	parent: null

Template.new.events
	'click': (e,t)->
		e.preventDefault() # prevent from re-rendering whole page
	'click #submitNew': (e,t)->
		unless title = t.find('#title').value?.trim() #($ '#title').val()?.trim()
			alert "title can't be empty"
		else
			#isChecked = ($ '#checked').val()
			#price = 1.0 * ($ '#price').val()#?.trim()
			#console.log this, 'clicked'

			Meteor.call "addPost",
				parent: null
				checked: true 
				title: title
				price: null
				project: project() #? alert 'set project first'
				#comments:[]
			$('#title').val('')
			#Router.go 'posts'
			#e.preventDefault() # prevent from re-rendering whole page
			#Session.set 'newItem',false

	'click #cancel': (e,t)->
		$('#title').val('')
		#$('#price').val('')
		#Router.go 'posts'
		#e.preventDefault() # prevent from re-rendering whole page
		#Session.set 'newItem', false


Template.newComment.helpers
	parent: @_id

Template.newComment.events
	'click': (e,t)->
		e.preventDefault() # prevent from re-rendering whole page

	'click #submit': (e,t) ->
		title = t.find('#title').value?.trim() #($ "##{@_id}").val()?.trim()
		price = t.find('#price').value #($ '#price').val()#?.trim()
		#isChecked = ($ '#checked').val()
		return unless title? and price?
		
		Meteor.call "addPost",
			parent: @_id 
			checked: true
			title: title
			price: 1.0 * price
			project:null
			#comments:[]
		(t.find '#price').value = null
		#$('#price').val('')
		(t.find '#title').value = '' #$('#title').val('').select().focus()
		(t.find '#title').select()#.focus()
		#Session.set "newComment#{@_id}",false

	'click #cancel': (e,t)->
		$('#price').val ''
		$('#title').val('').select()#.focus()
		#Session.set "newComment#{@_id}",false
		