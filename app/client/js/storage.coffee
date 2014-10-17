goog.provide 'app.Storage'

goog.require 'este.Storage'

class app.Storage extends este.Storage

  ###*
    @param {app.Dispatcher} dispatcher
    @param {app.LocalStorage} localStorage
    @param {app.Routes} routes
    @param {app.Xhr} xhr
    @param {app.songs.Store} songsStore
    @param {app.user.Store} userStore
    @constructor
    @extends {este.Storage}
    @final
  ###
  constructor: (@dispatcher, @localStorage, @routes, @xhr,
      @songsStore, @userStore) ->

    @localStorage.sync [@userStore]
    @dispatcher.register @onDispatch_.bind @

  @Actions:
    ROUTE_LOAD: 'route-load'

  ###*
    @param {este.Route} route
    @param {Object} params
    @return {!goog.Promise}
  ###
  load: (route, params) ->
    @dispatcher.dispatch Storage.Actions.ROUTE_LOAD,
      route: route
      params: params

  ###*
    @param {string} action
    @param {Object} payload
    @return {goog.Promise|undefined}
    @private
  ###
  onDispatch_: (action, payload) ->
    switch action
      when Storage.Actions.ROUTE_LOAD
        @loadRoute_ payload.route, payload.params
      when app.songs.Store.Actions.SEARCH
        @xhr
          .get @routes.api.songs.search.url null, query: payload.query
          .then (songs) =>
            @songsStore.fromJson foundSongs: songs

  ###*
    @param {este.Route} route
    @param {Object} params
    @return {!goog.Promise}
    @private
  ###
  loadRoute_: (route, params) ->
    switch route
      when @routes.about, @routes.home, @routes.newSong, @routes.trash
        @ok()
      when @routes.me
        return @notFound() if !@userStore.isLogged()
        @ok()
      when @routes.mySong, @routes.editSong
        return @notFound() if !@userStore.songById params.id
        @ok()
      when @routes.song
        @xhr
          .get @routes.api.songs.byUrl.url params
          .then (songs) =>
            return @notFound() if !songs.length
            @songsStore.fromJson songsByUrl: songs
      when @routes.songs
        @ok()
      when @routes.recentlyUpdatedSongs
        @xhr
          .get @routes.api.songs.recentlyUpdated.url()
          .then (songs) =>
            @songsStore.fromJson recentlyUpdatedSongs: songs
      else
        @notFound()
