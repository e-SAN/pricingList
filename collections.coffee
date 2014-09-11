#@Posts = new Meteor.Collection 'posts'
@Likes = new Meteor.Collection 'likes'
@WList = new Meteor.Collection 'WList'

		
	
@Schema = 
	schema:
		title:
			type: String
			label:'Item名'
			max:200	
		price:
			type: Number
			label: 'Price'
			optional: true
			decimal: true
		manday:
			type: Number
			label:'Man-day'
			optional:true
		parent: 
			type: String
			optional:true
			#custom: -> #to specify when parent is required
		checked:
			type: Boolean
		project:
			type: String
			optional:true
			#custom: -> 'required' unless parent?  
		date:
			type: Date
		lastCommentDate:
			type: Date
			optional: true
			#custom: -> 'required' unless parent? 

@Posts = new Meteor.Collection('posts', Schema)

Posts.allow
	insert: ->  true
	update: ->  true
	remove: ->  true
	fetch: []

@suma = (arr) ->
	s = 0
	s += item.getPrice() for item in arr when item.checked 
	s

Posts.helpers
	getPrice: ->
		return @price if @parent 
		suma (Posts.find parent: @_id).fetch()
