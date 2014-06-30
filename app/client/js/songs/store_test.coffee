suite 'app.songs.Store', ->

  Store = app.songs.Store
  store = null

  setup ->
    store = new Store

  validSong = ->
    validate: -> []

  invalidSong = ->
    validate: -> ['error']

  suite 'all', ->
    test 'should return empty array', ->
      songs = store.all()
      assert.deepEqual songs, []

  suite 'add', ->
    test 'should add valid model', (done) ->
      song = validSong()
      store.listen 'change', ->
        assert.deepEqual store.all(), [song]
        done()
      errors = store.add song
      assert.deepEqual errors, []

    test 'should not add invalid model', ->
      song = invalidSong()
      changeDispatched = false
      store.listen 'change', -> changeDispatched = true
      errors = store.add song
      assert.isFalse changeDispatched
      assert.deepEqual errors, song.validate()

  suite 'delete', ->
    test 'should delete model', (done) ->
      song = validSong()
      store.add song
      store.listen 'change', ->
        assert.deepEqual store.all(), []
        done()
      store.delete song

  suite 'songByRoute', ->
    test 'should return added song looked up with params', ->
      song = urlArtist: 'a', urlName: 'b', validate: -> []
      store.add song
      songByRoute = store.songByRoute params: urlArtist: 'a', urlName: 'b'
      assert.deepEqual songByRoute, song

    test 'should return null', ->
      assert.isNull store.songByRoute params: urlArtist: 'a', urlName: 'b'