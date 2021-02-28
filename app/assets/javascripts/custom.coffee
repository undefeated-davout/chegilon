# Fadeout alert
$ ->
  setTimeout (->
    $('.notice_message_box').fadeOut(2000)
    return
  ), 2000
