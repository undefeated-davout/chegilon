# Header's toggle bottun active or not(ON / OFF)
$ ->
  $('.navbar-toggle').click ->
    $(this).toggleClass('active')
    return
