class Reservations
  constructor: () ->
    @._toggleReservation()
    @._listenersOnInputs()
    @._fadeAwayAlerts()

  # reservations#index
  _toggleReservation: () ->
    $('.panel-heading.reservations').each (idx, el) ->
      $(el).click ->
        $(el).next().toggle()

  # reservations#new
  setAvailableTables: (date, people, id) ->
    params = {}
    params['date'] = date if date.length > 0
    params['people'] = people if people.length > 0
    params['id'] = id
    $.get(
      '/tables/restrict',
      params,
      (data) ->
        window.Reservations.restrictTables(data)
      'json'
    )

  restrictTables: (ids) ->
    $('#tables-list .table').each (idx, el) ->
      id = parseInt($(el).attr('class').match(/table-id-\d{0,2}/)[0].split('-')[2])
      if $.inArray(id, ids) != -1
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

$(document).on 'turbolinks:load', ->
  window.Reservations = new Reservations
