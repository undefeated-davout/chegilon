$ ->
  initMenu = ->
    $('#menu ul').hide()
    $('#menu ul').children('.current').parent().show()
    $('#menu li a').click ->
      checkElement = $(this).next()
      if checkElement.is('ul') and checkElement.is(':visible')
        return false
      if checkElement.is('ul') and !checkElement.is(':visible')
        $('#menu ul:visible').slideUp 'normal'
        checkElement.slideDown 'normal'
        return false
      return
    return

  $('#menu-toggle-2').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass 'toggled-2'
    $('#menu ul').hide()
    return
  $(document).ready ->
    initMenu()
    return
