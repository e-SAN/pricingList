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
  @route 'printing'
  ###
  @route 'fullPost', 
    path:'/post/:_id'
    data: -> 
      post = Posts.findOne _id: @params._id
      post.comments = Posts.find 
        parent: @params._id 
        sort: date: 1
      post.price =  for post in post.comments
        post.price ? 0 += post.price
      post
  @route 'fullPost', 
    path:'/post/:_id'
    data: -> Posts.findOne _id: @params._id #$or: [_id: @params._id , parent: @params._id]
  ###
  ###
  @route 'searchResults',
    path: '/posts/:searchKey'
    data: -> Posts.find title: @params.searchKey
  ###
