class Tables
  constructor: () ->
    @._initEditTable()
    @._initSaveTable()

  _initEditTable: () ->
    $('.edit-table').each (idx, el) ->
      $(el).click (ev) ->
        ev.preventDefault()
        $(el).hide()
        $(el).next().removeClass('hidden')

        $input = $(el).closest('tr').find('td.hidden')
        $input.removeClass('hidden')
        $input.next().hide()

  _initSaveTable: () ->
    $('.save-table').each (idx, el) ->
      $(el).click (ev) ->
        ev.preventDefault()

        $(el).addClass('hidden')
        $(el).prev().show()

        $input = $($(el).closest('tr').children()[1])
        $input.addClass('hidden')
        $seatsCol = $input.next()
        $seatsCol.show()

        if window.Tables.updateTable(el)
          $seatsCol.text("#{$input.find('input').val()}")
          $seatsCol.find('span').addClass('success').removeClass('error').text('SUKCES')
        else
          $seatsCol.text("#{$input.find('input').val()}")
          $seatsCol.find('span').addClass('error').removeClass('succes').text('BŁĄD')

  updateTable: (el) ->
    $input = $(el).closest('tr').find('input')
    id = $input.attr('id').split('_')[1]

    $.ajax "/tables/#{id}",
      type: 'PUT',
      dataType: 'json',
      data: { seats: $input.val() },
      error: (jqXHR, textStatus, errorThrown) ->
        false
      success: (data, textStatus, jqXHR) ->
        true

$(document).on 'turbolinks:load', ->
  window.Tables = new Tables
