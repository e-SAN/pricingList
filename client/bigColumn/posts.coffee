###
Template.searchform.events 
	'click #search': (e,t) ->
		unless key = $('#searchKey').val()?
			return
		else
			Meteor.go "searchResults"


###
Template.wlist.visible = ->
	Meteor.user()?.username in ['J.K', 'athena'] #this is not safe
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

Template.posts.rendered = ->
	Deps.autorun ->
		Meteor.subscribe "posts", Meteor.user()?.username
		#Meteor.subscribe "likes"
		#Meteor.subscribe "appusers", Meteor.userId()

Template.posts.posts = ->
	Posts.find parent:null, 
		sort: lastCommentDate:-1	

###
###
Template.fullPost.rendered = ->
	Deps.autorun ->
		Meteor.subscribe "posts", Meteor.user()?.username
		#Meteor.subscribe "post", Meteor.user()?.username, @_id
		#Meteor.subscribe "comments", Meteor.user()?.username, @_id

Template.commentsList.rendered = ->
	Deps.autorun ->
		#Meteor.subscribe "posts", Meteor.user()?.username
		#Meteor.subscribe "post", Meteor.user()?.username, @_id
		Meteor.subscribe "comments", Meteor.user()?.username, @_id
	
	

Template.commentsList.comments = ->
	Posts.find parent: @_id,
		sort: date: 1


Template.new.events
	'click #submitNew': (e,t)->
		unless title = ($ '#title').val()?.trim()
			alert "title can't be empty"
		else
			content = ($ '#content').val()#?.trim()
			#console.log this, 'clicked'

			Meteor.call "addPost",
				parent: null 
				title: title
				content: content
				#comments:[]
			Router.go 'posts'
			e.preventDefault() # prevent from re-rendering whole page
	
	'click #cancel': (e,t)->
		$('#title').val('')
		$('#content').val('')
		Router.go 'posts'
		e.preventDefault() # prevent from re-rendering whole page
		
Template.newComment.events
	'click #submit': (e,t) ->
		title = ($ '#title').val()?.trim()
		content = ($ '#content').val()#?.trim()
		unless title 
			unless content?
				return
			#console.log this, 'clicked'
		
		Meteor.call "addPost",
			parent: @_id 
			title: title
			content: content
			#comments:[]

		$('#content').val('')
		$('#title').val('').select().focus()
		e.preventDefault() # prevent from re-rendering whole page
			
	'click #cancel': (e,t)->
		$('#content').val ''
		$('#title').val('').select().focus()
		e.preventDefault() # prevent from re-rendering whole page
