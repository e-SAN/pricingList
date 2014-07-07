Meteor.startup ->
	if Meteor.userId()? 
		unless (localStorage.getItem 'userId')?
			localStorage.setItem "userId", Meteor.userId()
		unless (localStorage.getItem 'username')? 
			localStorage.setItem "username", Meteor.user().username

Template.layout.loggedIn = ->
	#Meteor.userId()?
	(localStorage.getItem "userId")?

###
Template.searchform.events 
	'click #search': (e,t) ->
		unless key = $('#searchKey').val()?
			return
		else
			Meteor.go "searchResults"


###

Template.wlist.visible = ->
	#Meteor.user()?.username in ['J.K', 'athena'] #this is not safe
	localStorage.getItem("username") in ['J.K', 'athena']

Template.wlist.jk = ->
	#Meteor.user()?.username is 'J.K' #not safe
	localStorage.getItem('username') is 'J.K'

Template.wlist.events
	'click #addUser':(e,t) ->
		unless (username = t.find('#username').value?.trim())?
			return
		else	
			Meteor.call "addUser", localStorage.getItem('username'),username #Meteor.user().username, username
			$('#username').val('').select().focus()
			#console.log this, username
	'click #removeUser':(e,t) ->
		unless (username = t.find('#username').value?.trim())?
			return
		else	
			Meteor.call "removeUser",localStorage.getItem('username'),username #Meteor.user().username, username
			$('#username').val('').select().focus()
			#console.log this, username

Template.posts.rendered = ->
	Deps.autorun ->
		Meteor.subscribe "posts", localStorage.getItem 'username' #Meteor.user()?.username
		Meteor.subscribe "post", localStorage.getItem('username'), @_id #Meteor.user()?.username, @_id
		Meteor.subscribe "comments", localStorage.getItem('username'), @_id #Meteor.user()?.username, @_id
		Meteor.subscribe "likes"
		Meteor.subscribe "appusers", localStorage.getItem 'username' #Meteor.userId()

Template.posts.posts = ->
	Posts.find parent:null, 
		sort: lastCommentDate:-1	


Template.fullPost.rendered = ->
	Deps.autorun ->
		Meteor.subscribe "posts", localStorage.getItem('username') #Meteor.user()?.username
		Meteor.subscribe "post", localStorage.getItem('username'), @_id #Meteor.user()?.username, @_id
		Meteor.subscribe "comments", localStorage.getItem('username'), @_id #Meteor.user()?.username, @_id

Template.commentsList.rendered = ->
	Deps.autorun ->
		#Meteor.subscribe "posts", Meteor.user()?.username
		Meteor.subscribe "post", localStorage.getItem('username'), @_id #Meteor.user()?.username, @_id
		Meteor.subscribe "comments", localStorage.getItem('username'), @_id #Meteor.user()?.username, @_id
		

Template.commentsList.comments = ->
	Posts.find parent: @_id,
		sort: date: 1

Template.new.loggedIn = ->
	Meteor.userId()?

Template.new.events
	'click #submitNew': (e,t)->
		unless title = t.find('#title').value?.trim()
			alert "title can't be empty"
		else
			content = t.find('#content').value?.trim()
			#console.log this, 'clicked'

			Meteor.call "addPost",
				parent: null 
				title: title
				content: content
				#comments:[]
			Router.go 'posts'
	
	'click #cancel': (e,t)->
		$('#title').val('')
		$('#content').val('')
		Router.go 'posts'

Template.newComment.events
	'click #submit': (e,t) ->
		title = t.find('#title').value?.trim()
		content = t.find('#content').value?.trim()
		unless title 
			unless content
				return
			#console.log this, 'clicked'
		
		Meteor.call "addPost",
			parent: @_id 
			title: title
			content: content
			#comments:[]
		
		$('#content').val('')
		$('#title').val('').select().focus()
				
			

	'click #cancel': (e,t)->
		$('#content').val ''
		$('#title').val('').select().focus()
		