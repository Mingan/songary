suite 'app.Dispatcher', ->

  Dispatcher = app.Dispatcher
  dispatcher = null

  setup ->
    errorReporter = report: ->
    dispatcher = new Dispatcher errorReporter

  suite 'register', ->
    test 'should throw error if arg is not function', ->
      assert.throws ->
        dispatcher.register 'foo'
      , 'Assertion failed: Expected function but got string: foo'

  suite 'unregister', ->
    test 'should throw error if id was not registered', ->
      assert.throws ->
        dispatcher.unregister 123
      , 'Assertion failed: `123` does not map to a registered callback.'

  suite 'dispatch', ->
    test 'should call registered callback with action and payload', (done) ->
      action = 'action'
      payload = {}
      dispatcher.register (action_, payload_) ->
        assert.equal action_, action
        assert.equal payload_, payload
        done()
      dispatcher.dispatch action, payload

    test 'should work without error reporter', (done) ->
      dispatcher = new Dispatcher
      dispatcher.register ->
      dispatcher.dispatch 'action', {}
        .then -> done()

    test 'should run callbacks and return all promise', (done) ->
      called = 0
      dispatcher.register (action, payload) -> called++
      dispatcher.register (action, payload) -> called++
      dispatcher
        .dispatch 'action', a: 1
        .then (value) ->
          assert.deepEqual value, [{a: 1}, {a: 1}]
          assert.equal called, 2
          done()

    test 'should report promise if returned', (done) ->
      dispatcher.register (action, payload) ->
        goog.Promise.resolve 123
      dispatcher
        .dispatch 'action', a: 1
        .then (value) ->
          # Yes, 123 should not be returned.
          assert.deepEqual value, [a: 1]
          done()

    test 'should catch error in callback', (done) ->
      called = false
      dispatcher = new Dispatcher report: -> called = true
      dispatcher.register (action, payload) ->
        throw 'error'
      dispatcher
        .dispatch 'action', a: 1
        .thenCatch (reason) ->
          assert.isTrue called
          assert.equal reason, 'error'
          done()

    test 'should call error report if rejected promise is returned', (done) ->
      handleCalled = false
      error = report: (reason, action) ->
        assert.equal reason, 'error'
        assert.equal action, 'action'
        handleCalled = true
      dispatcher = new Dispatcher error
      dispatcher.register (action, payload) ->
        assert.deepEqual payload, {}
        goog.Promise.reject 'error'
      dispatcher
        .dispatch 'action', {}
        .thenCatch (reason) ->
          assert.equal reason, 'error'
          assert.isTrue handleCalled
          done()

    test 'should throw error if action is not string', ->
      assert.throws ->
        dispatcher.dispatch 1
      , 'Assertion failed: Expected string but got number: 1'

    test 'should throw error if payload is not object', ->
      assert.throws ->
        dispatcher.dispatch 'foo', 1
      , 'Assertion failed: Expected object but got number: 1'

    test 'should throw error if called during dispatching', (done) ->
      dispatcher.register (action, payload) ->
        assert.throws ->
          dispatcher.dispatch 'action', {}
        , 'Assertion failed: Cannot dispatch in the middle of a dispatch.'
        done()
      dispatcher.dispatch 'action', {}

    # test 'should detect circular dependency', (done) ->
    #   indexA = dispatcher.register (action, payload) ->
    #     dispatcher.waitFor [indexB]
    #   indexB = dispatcher.register (action, payload) ->
    #     assert.throws ->
    #       dispatcher.waitFor [indexA]
    #     , 'Assertion failed: Circular dependency detected for: '
    #     done()
    #   dispatcher.dispatch 'action', {}
    #     .thenCatch ->

    # todo: a na a, a je to ok

  suite 'waitFor', ->
    test 'should wait', (done) ->
      called = ''
      indexA = dispatcher.register ->
        dispatcher
          .waitFor [indexB]
          .then -> called += 'a'
      indexB = dispatcher.register ->
        called += 'b'
      dispatcher
        .dispatch 'action', {}
        .then (value) ->
          assert.deepEqual value, [{}, {}]
          assert.equal called, 'ba'
          done()

    test 'should throw error if not called during dispatching', ->
      assert.throws ->
        dispatcher.waitFor [1]
      , 'Assertion failed: Must be invoked while dispatching.'

    test 'should throw error if indexes is not an array', (done) ->
      dispatcher.register (action, payload) ->
        assert.throws ->
          dispatcher.waitFor 123
        , "Assertion failed: Expected array but got number: 123"
        done()
      dispatcher.dispatch 'action', {}

    test 'should throw error if callback is unknown', (done) ->
      dispatcher.register (action, payload) ->
        assert.throws ->
          dispatcher.waitFor [123]
        , 'Assertion failed: `123` does not map to a registered callback'
        done()
      dispatcher.dispatch 'action', {}
