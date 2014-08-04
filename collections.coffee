@Posts = new Meteor.Collection 'posts'
@Likes = new Meteor.Collection 'likes'
@WList = new Meteor.Collection 'WList'

@suma = (arr) ->
	s = 0
	for n in arr when n.checked 
		s += n.getPrice()
	s

Posts.helpers
	getPrice: ->
		if @parent then return @price
		suma (Posts.find parent: @_id).fetch()
		
	
###
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
		parent: 
			type: String
			optional:true
			#custom: -> #to specify when parent is required
		checked:
			type: Boolean
@Posts = new Meteor.Collection('posts', Schema)
###


