class Hrguru.Views.ScheduledUsersFilters extends Marionette.View
  el: '#filters'

  events:
    'click .category': 'activateCategory'

  ui:
    tabs: '.category'

  initialize: (@abilities, @roles, @users) ->
    @initializeVariables()
    @bindUIElements()
    @countUsersInCategories()
    H.setCurrentSchedulingCategory(@ui.tabs.first().data('category'))

  initializeVariables: ->
    @selectize =
      abilities: []
      roles: []
      category: ''

  render: ->
    @initializeAbilitiesFilter()
    @initializeRoleFilter()
    @sortUsersInTab(@ui.tabs.first())

  activateCategory: (e) ->
    $tab = $(e.target).closest('.category')
    return unless $tab.hasClass('category')
    @ui.tabs.removeClass('active')
    $tab.addClass('active')
    @selectize.category = $tab.data('category')
    H.setCurrentSchedulingCategory(@selectize.category)
    @sortUsersInTab($tab)
    @filterUsers()

  sortUsersInTab: (tab) ->
    sortDirection = tab.data('sort-direction') || 0
    @sortUsers(tab.data('sort'), sortDirection)

  countUsersInCategories: ->
    @ui.tabs.each (index, tab) =>
      $tab = $(tab)
      userCount = @users.inSchedulingCategory($tab.data('category')).length
      $tab.find('.user-count').text("(#{userCount})")

  initializeRoleFilter: ->
    roles_selectize = @$('input[name=roles]').selectize
      plugins: ['remove_button']
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      sortField: 'priority'
      options: @roles.toJSON()
      onItemAdd: @filterUsers
      onItemRemove: @filterUsers
    @selectize.roles = roles_selectize[0].selectize.items

  initializeAbilitiesFilter: ->
    abilities_selectize = @$('input[name=abilities]').selectize
      plugins: ['remove_button']
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      sortField: 'name'
      options: @abilities
      onItemAdd: @filterUsers
      onItemRemove: @filterUsers
    @selectize.abilities = abilities_selectize[0].selectize.items

  filterUsers: =>
    @renderUsers()
    EventAggregator.trigger('users:updateVisibility', @selectize)
    H.addUserIndex()

  renderUsers: ->
    EventAggregator.trigger('scheduledUsers:render')

  sortUsers: (attr, direction) ->
    EventAggregator.trigger('scheduledUsers:sort', attr, direction)