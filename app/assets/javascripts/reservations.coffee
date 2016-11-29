# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Reservations
  constructor: () ->
    @._toggleReservation()
    @._toggleOldReservations()
    @._listenersOnInputs()
    @._fadeAwayAlerts()
    @._initShowNote()

  # reservations#index
  _toggleReservation: () ->
    $('.panel-heading').each (idx, el) ->
      $(el).click ->
        $(el).next().toggle()

  _toggleOldReservations: () ->
    $('p.header-old').click ->
      $(@).next().slideToggle()
      $el = $('i', $(@))
      if $el.hasClass('glyphicon-chevron-down')
        $el.removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up')
      else
        $el.removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down')

  # reservations#new
  setAvailableTables: (date, people, id) ->
    params = {}
    params['date'] = date if date.length > 0
    params['people'] = people if people.length > 0
    params['id'] = id
    $.get(
      '/reservations/restrict_tables',
      params,
      (data) ->
        window.Reservations.restrictTables(data)
      'json'
    )

  restrictTables: (ids) ->
    $('#tables-list .table').each (idx, el) ->
      if $.inArray(idx + 1, ids) != -1
        $(el).removeClass('error').addClass('success')
      else
        $(el).removeClass('success').addClass('error')

    if $.inArray(parseInt($('.selectpicker').val()), ids) == -1
      $('#wrong-table').fadeIn(750)
    else
      $('#wrong-table').fadeOut(1000)


  _listenersOnInputs: () ->
    $('#reservation_table_id, #reservation_date, #reservation_people').on 'change blur', =>
      date = $(".form-control[id$='date']").val()
      people = $(".form-control[id$='people']").val()
      id = $('form').attr('id').split('_')[2]
      id = 0 if id == undefined
      @.setAvailableTables(date, people, id)

  _fadeAwayAlerts: () ->
    setTimeout ->
      $(".alert:not('.alert-warning')").fadeOut(1000)
    , 3000

  _initShowNote: () ->
    $('.show-note').click (ev) ->
      ev.preventDefault()


$(document).on 'turbolinks:load', ->
  window.Reservations = new Reservations
