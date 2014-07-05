Router.configure
  layoutTemplate: 'layout'
  notFoundTemplate: 'notFound'
  loadingTemplate: 'loading'
  waitOn: -> 
    Meteor.subscribe 'posts', Meteor.userId()
    #Meteor.subscribe 'comments', @_id

Router.map -> # => will not work
  @route 'splash', path: '/'
  @route 'new'#, onAfterAction: -> this.render 'posts'
  @route 'posts'
  @route 'fullPost', 
    path:'/posts/:_id'
    data: -> Posts.findOne @params._id #, parent: @params._id
  ###
  @route 'searchResults',
    path: '/posts/:searchKey'
    data: -> Posts.find title: @params.searchKey
  ###
