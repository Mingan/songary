goog.provide 'app.react.Footer'

class app.react.Footer

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    {footer} = React.DOM

    @create = React.createClass

      render: ->
        footer null, Footer.MSG_FOO

  @MSG_FOO: goog.getMsg ''