Template.signup.events
	'click button': (e,t) ->
		e.preventDefault()
		Accounts.createUser
			email: ($ '#su-email').val()
			username: ($ '#su-username').val()
			password: ($ '#su-password').val()
		Session.set 'signup',false

Template.signupLogin.visable = ->
	Session.get 'signup'

Template.login.events
	'click button': (e, t) ->
		e.preventDefault()
		Meteor.loginWithPassword ($ '#li-username').val(), 
			($ '#li-password').val()
			(err)-> console.log err

	'click a': (e, t) ->
		e.preventDefault()
		Session.set 'signup',true 

Template.logout.events
	'click button': (e,t) ->
		e.preventDefault()
		Meteor.logout()
