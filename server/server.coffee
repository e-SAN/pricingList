approved = (name) ->
	return false unless name?
	name is 'J.K' or WList.findOne(username:name)?

share.approved = approved

Meteor.publish "posts", (username)->
	if approved username #and username? in ['j.k'] #<--this works! so we will add white-list
		Posts.find {} #parent:null #,
			#fields:
			#	content:false
				#owner:false

Meteor.publish "comments", (username, id)->
	if id? and approved username
		Posts.find parent:id #,
			###
				fields:
				content:false
				#owner:false
			###
Meteor.publish "likes", (postid)->
	Likes.find post:postid

Meteor.publish "appusers", (userid) ->
	if userid?
		Meteor.users.find()

Meteor.methods
	# {content:'',owner:'',date:'',parent:''}
	'postOwner':(id) ->
		# this doesn't work
		posts = (Posts.find _id: id).fetch()
		userid = posts[0].owner
		usr = (Meteor.users.find _id: userid).fetch()[0]
		console.log usr.emails?[0].address
		usr.emails[0].address
		if usr? 
			if usr.profile? 
				usr.profile.name 
			else 
				usr.emails?[0].address
		else
			userid 
		
	'addUser':(username, newname)->
		if approved username
			WList.insert 
				username: newname 
				by: username

	'removeUser':(username, thename)->
		if username is 'J.K'
			WList.remove 
				username: thename 
		
	'addPost':(options)->
		username = Meteor.user().username
		return unless approved username
			
		date = new Date()
		id = options.parent
		post = {
			checked: options.checked
			title: options.title
			price: options.price
			owner: username #"#{Meteor.user().username}(#{Meteor.user().emails[0].address})" #if (em = Meteor.user().emails?[0]?.address)? then em else Meteor.userId()
			date: date
			parent: id
			project: options.project # this is usefull later for adding selecting method
		}
		
		if id?
			Posts.update id,
				$set: lastCommentDate: date
		else
			post.lastCommentDate = date  
		
		Posts.insert post
		#console.log post, (Posts.find date: post.date).fetch()

	'isChecked': (id, bool)->
		Posts.update id, 
			$set: checked: bool

	'removePost': (id)->
		Posts.remove _id:id
		# Can later be changed to:
		#Posts.update id,
		#	$set: removed: true

	
	'removeAllPosts':()->
		Posts.remove {}
###
	'addNames':()->
		Meteor.users.update 'tgHnK8gQ46GXRAGtv', $set: {'profile.fullname': 'Mike Tyson' }
		Meteor.users.update 'Xr9viZQzp6KbvX6b7', $set: {'profile.fullname': 'Evander Holyfield' }
###