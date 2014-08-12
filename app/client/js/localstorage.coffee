goog.provide 'app.LocalStorage'

goog.require 'common.Storage'
goog.require 'goog.array'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'

class app.LocalStorage

  ###*
    @constructor
  ###
  constructor: ->
    @tryCreate()
    @migrate()

  localStorageKey: 'songary'
  localStorageVersion: 1

  ###*
    Can be null, Safari in private mode does not allow localStorage.
    @type {goog.storage.Storage}
    @protected
  ###
  localStorage: null

  ###*
    @protected
  ###
  tryCreate: ->
    mechanism = goog.storage.mechanism.mechanismfactory
      .createHTML5LocalStorage @localStorageKey
    return if !mechanism
    @localStorage = new goog.storage.Storage mechanism
    @ensureVersion()

  ensureVersion: ->
    version = @localStorage.get '@version'
    return if version
    # NOTE(steida): Update to version 1.
    @localStorage.remove 'songs'
    @localStorage.set '@version', @localStorageVersion

  ###*
    @protected
  ###
  migrate: ->
    return if !@localStorage
    storageVersion = Number @localStorage.get '@version'
    scriptVersion = @localStorageVersion
    userOrig = @localStorage.get 'user'
    try
      migrateVersion() for migrateVersion in [
        =>
          # Example:
          # user = @localStorage.get 'user'
          # user.songs = user.songs.map (song) ->
          #   lyrics = song.lyrics
          #   delete song.lyrics
          #   song.llyrics = lyrics
          #   song
          # @localStorage.set 'user', user
        =>
          # console.log 'from 2 to 3'
      ].slice storageVersion - 1, scriptVersion - 1
    catch e
      # TODO(steida): Report error to server.
      @localStorage.set 'user', userOrig
      return
    @localStorage.set '@version', scriptVersion
    return

  ###*
    @param {Array.<app.Store>} stores
  ###
  load: (stores) ->
    return if !@localStorage
    @loadFromJson stores
    @listenWindowStorage stores

  ###*
    @param {Array.<app.Store>} stores
    @protected
  ###
  loadFromJson: (stores) ->
    stores.forEach (store) =>
      json = @localStorage.get store.name
      return if !json
      # TODO(steida): Try/Catch in case of error. Report error to server.
      store.fromJson json

  ###*
    Sync app state across tabs/windows.
    @param {Array.<app.Store>} stores
    @protected
  ###
  listenWindowStorage: (stores) ->
    # IE 9/10/11 implementation of window storage event is broken. Check:
    # http://stackoverflow.com/a/4679754
    return if goog.labs.userAgent.browser.isIE()

    goog.events.listen window, 'storage', (e) =>
      # TODO(steida): Reload if localStorageVersion changed.
      browserEvent = e.getBrowserEvent()
      storeName = browserEvent.key.split('::')[1]
      return if !storeName
      store = goog.array.find stores, (store) -> store.name == storeName
      return if !store

      # NOTE(steida): Because FirebaseSimpleLogin does not propagate login
      # state across browser windows, we need to track change manually.
      if store instanceof app.user.Store
        userWasLogged = !!store.user

      # TODO(steida): Try/Catch in case of error. Report error to server.
      json = (`/** @type {Object} */`) JSON.parse browserEvent.newValue
      store.fromJson json
      store.serverNotify()

      # NOTE(steida): Reload browser if user login state has changed.
      if store instanceof app.user.Store
        userLogged = !userWasLogged && store.user
        userLogout = userWasLogged && !store.user
        location.reload() if userLogged || userLogout

  ###*
    @param {este.labs.Store} store
    @param {Object} storeAsJson
  ###
  set: (store, storeAsJson) ->
    return if !@localStorage
    @localStorage.set store.name, storeAsJson