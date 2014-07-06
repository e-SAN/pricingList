Router.configure
  layoutTemplate: 'layout'
  notFoundTemplate: 'notFound'
  loadingTemplate: 'loading'
  #waitOn: -> 
  #  Meteor.subscribe 'posts', Meteor.userId()
    #Meteor.subscribe 'comments', @_id

Router.map -> # => will not work
  @route 'splash', 
    path: '/'
    onAfterAction: -> this.render 'posts'
  @route 'new'
  @route 'posts'
  @route 'fullPost', 
    path:'/post/:_id'
    data: -> Posts.findOne @params._id #, parent: @params._id
  ###
  @route 'searchResults',
    path: '/posts/:searchKey'
    data: -> Posts.find title: @params.searchKey
  ###
