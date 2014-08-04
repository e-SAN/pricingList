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
@Likes = new Meteor.Collection('likes')
@WList = new Meteor.Collection('WList')

