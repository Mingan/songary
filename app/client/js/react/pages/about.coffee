goog.provide 'app.react.pages.About'

goog.require 'goog.ui.Textarea'

class app.react.pages.About

  ###*
    @param {app.user.Store} userStore
    @param {app.Firebase} firebase
    @constructor
  ###
  constructor: (userStore, firebase) ->
    {div,p,form,textarea,menu,button} = React.DOM

    message = ''

    @component = React.createClass

      render: ->
        div className: 'page',
          p {}, About.MSG_P
          userStore.isLoggedIn() &&
            form className: 'contact-form',
              div className: 'form-group',
                textarea
                  autoFocus: true
                  className: 'form-control'
                  onChange: @onContactFormMessageChange
                  placeholder: About.MSG_SEND_PLACEHOLDER
                  ref: 'message'
                  value: message
              button
                className: 'btn btn-default'
                disabled: !message.length
                onClick: @onContactFromSubmit
                type: 'button'
              , About.MSG_SEND_BUTTON_LABEL

      onContactFormMessageChange: (e) ->
        message = e.target.value.slice 0, 499
        @forceUpdate()

      onContactFromSubmit: ->
        if message.length < 9
          alert @getSuspiciousMessageWarning message
          return
        user = userStore.user
        firebase.sendContactFormMessage user.uid, user.displayName, message
        alert About.MSG_THANK_YOU
        message = ''
        @forceUpdate()

      getSuspiciousMessageWarning: (message) ->
        About.MSG_FOK = goog.getMsg 'Is "{$message}" really what you want to tell us?',
          message: message

      componentDidMount: ->
        @messageTextarea = new goog.ui.Textarea ''
        el = @refs['message']?.getDOMNode()
        @messageTextarea.decorate el if el

      componentWillUnmount: ->
        @messageTextarea.dispose()

  @MSG_P: goog.getMsg 'Songary. Your songbook.'
  @MSG_SEND_PLACEHOLDER: goog.getMsg 'Compliments, complaints, or suggestions.'
  @MSG_SEND_BUTTON_LABEL: goog.getMsg 'Let us know '
  @MSG_THANK_YOU: goog.getMsg 'Thank you.'