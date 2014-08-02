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
		checked:
			type: String

@Posts = new Meteor.Collection('posts', Schema)
@Likes = new Meteor.Collection('likes')
@WList = new Meteor.Collection('WList')

