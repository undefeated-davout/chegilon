$ ->
  $('.scroll_fadein').css("opacity", "0")

  $(window).load ->
    scroll_fadein()

  $(window).scroll ->
    scroll_fadein()

  # fadeIn method
  scroll_fadein = ->
    $('.scroll_fadein').each ->
      imgPos = $(this).offset().top
      scroll = $(window).scrollTop()
      windowHeight = $(window).height()
      if scroll > imgPos - windowHeight + 200
        $(this).addClass('animated fadeInUp')
      return
    return
  return
