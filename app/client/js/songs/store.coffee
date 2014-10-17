goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
goog.require 'este.Store'

class app.songs.Store extends este.Store

  ###*
    @param {app.Dispatcher} dispatcher
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @constructor
    @extends {este.Store}
  ###
  constructor: (@dispatcher, @routes, @userStore) ->
    super()
    @name = 'songs'

    ###* @type {Array.<app.songs.Song>} ###
    @recentlyUpdatedSongs = []

    ###* @type {Array.<app.songs.Song>} ###
    @songsByUrl = []

    ###* @type {Array.<app.songs.Song>} ###
    @foundSongs = []

    # @dispatcherId = @dispatcher.register @handleAction_.bind @

  @Actions:
    # PUBLISH_SONG: 'publishsong'
    SEARCH: 'searchsongs'
    # UNPUBLISH_SONG: 'unpublishsong'

  # handleAction_: (action, payload) ->
  #   switch action
  #     when Store.Actions.PUBLISH_SONG
  #       @xhr
  #         .put @routes.api.songs.id.url(id: payload.song.id), payload.json
  #         .then => @userStore.setSongPublisher payload.song
  #     when Store.Actions.UNPUBLISH_SONG
  #       @xhr
  #         .delete @routes.api.songs.id.url(id: payload.song.id)
  #         .then => @userStore.removeSongPublisher payload.song

  ###*
    @override
  ###
  fromJson: (json) ->
    toSong = (json) => new app.songs.Song json
    if json.foundSongs
      @foundSongs = json.foundSongs.map toSong
    if json.recentlyUpdatedSongs
      @recentlyUpdatedSongs = json.recentlyUpdatedSongs.map toSong
    if json.songsByUrl
      @songsByUrl = json.songsByUrl.map toSong
    @notify()

  ###*
    @param {app.songs.Song} song
    @return {goog.Promise}
  ###
  publish: (song) ->
    # publishedSong = @createPublishedSong_ song
    # errors = publishedSong.validatePublished()
    # if errors.length
    #   return goog.Promise.reject errors
    #
    # @dispatcher.dispatch Store.Actions.PUBLISH_SONG,
    #   song: song
    #   json: publishedSong.toJson()

  ###*
    @param {app.songs.Song} song
    @return {app.songs.Song}
    @private
  ###
  createPublishedSong_: (song) ->
    # json = song.toJson()
    # json.publisher = @userStore.user.uid
    # delete json.inTrash
    # @instanceFromJson app.songs.Song, json

  ###*
    @param {app.songs.Song} song
    @return {goog.Promise}
  ###
  unpublish: (song) ->
    # @dispatcher.dispatch Store.Actions.UNPUBLISH_SONG,
    #   song: song

  ###*
    @param {string} query
    @return {goog.Promise}
  ###
  search: (query) ->
    @dispatcher.dispatch Store.Actions.SEARCH, query: query
