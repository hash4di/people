removeFormControlClass = ->
  $('#js-user-abilities').removeClass('form-control')

initializeAbilities = ->
  selectize = $('#js-user-abilities').selectize
    plugins: ['remove_button', 'drag_drop']
    delimiter: ','
    persist: false
    create: (input) ->
      value: input
      text: input

$ ->
  removeFormControlClass()
  initializeAbilities()
