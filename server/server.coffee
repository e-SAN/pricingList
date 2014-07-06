Meteor.publish "post", (id)->
	Posts.findOne id

Meteor.publish "posts", (userid)->
	Posts.find {}#parent:null,
		#fields:
		#	content:false
			#owner:false

Meteor.publish "comments", (id)->
	if userid? and id?
		Posts.find parent:id #,
			###
				fields:
				content:false
				#owner:false
			###
Meteor.publish "likes", (postid)->
	Likes.find post:postid

Meteor.publish "appusers", (userid) ->
	if useriddd?
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
		

	'addPost':(options)->
		date = new Date()
		id = options.parent
		post = {
			title: options.title
			content: options.content
			owner: Meteor.user().username #"#{Meteor.user().username}(#{Meteor.user().emails[0].address})" #if (em = Meteor.user().emails?[0]?.address)? then em else Meteor.userId()
			date: date
			parent: id
		}
		
		if id?
			Posts.update id,
				$set: lastCommentDate: date
		else
			post.lastCommentDate = date  
		
		Posts.insert post
		#console.log post, (Posts.find date: post.date).fetch()

	'removePost':(id)->
		Posts.remove _id:id
	
	'removeAllPosts':()->
		Posts.remove {}
	
	'addNames':()->
		Meteor.users.update 'tgHnK8gQ46GXRAGtv', $set: {'profile.fullname': 'Mike Tyson' }
		Meteor.users.update 'Xr9viZQzp6KbvX6b7', $set: {'profile.fullname': 'Evander Holyfield' }
	