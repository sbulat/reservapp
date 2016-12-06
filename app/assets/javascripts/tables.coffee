class Tables
  constructor: () ->
    @._initEditTable()
    @._initSaveTable()
    # @._initRemoveSpan()

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

        $.when(window.Tables.updateTable(el)).done (res) ->
          if res['message'] == 'success'
            $seatsCol.text("#{$input.find('input').val()}")
            $seatsCol.append(window.Tables.createSpan())
          else
            $seatsCol.append(window.Tables.createSpan('error'))

          window.Tables.removeSpan()

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
        if data['message'] == 'success' then true else false

  createSpan: (msg = 'success') ->
    $span = $(document.createElement('span'))
    $span.addClass('msg pull-right').addClass(msg)
    $span.text(if msg == 'success' then 'SUKCES' else 'BŁĄD')
    $span

  removeSpan: () ->
    $span = $('span.msg')
    $span.fadeOut(2000)
    setTimeout ->
      $span.remove()
    , 2000

$(document).on 'turbolinks:load', ->
  window.Tables = new Tables
