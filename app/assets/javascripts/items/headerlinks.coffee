$ ->
# Yielding headlines from H1 - H6 tags
  idcount = 1
  toc = '<h2 id="header_link_title">目次</h2>'
  currentlevel = 0
  maxlevel = 6
  $('.tocChild :header').each ->
    if @nodeName.toLowerCase() == 'h1'
      level = 1
    if @nodeName.toLowerCase() == 'h2'
      level = 2
    if @nodeName.toLowerCase() == 'h3'
      level = 3
    else if @nodeName.toLowerCase() == 'h4'
      level = 4
    else if @nodeName.toLowerCase() == 'h5'
      level = 5
    else if @nodeName.toLowerCase() == 'h6'
      level = 6
    if maxlevel > level
      maxlevel = level
  currentlevel = maxlevel - 1
  $('.tocChild :header').each ->
    @id = 'toc_' + idcount
    idcount++
    level = 0
    if @nodeName.toLowerCase() == 'h1'
      level = 1
    if @nodeName.toLowerCase() == 'h2'
      level = 2
    if @nodeName.toLowerCase() == 'h3'
      level = 3
    else if @nodeName.toLowerCase() == 'h4'
      level = 4
    else if @nodeName.toLowerCase() == 'h5'
      level = 5
    else if @nodeName.toLowerCase() == 'h6'
      level = 6
    while currentlevel < level
      toc += '<ol>'
      currentlevel++
    while currentlevel > level
      toc += '</ol>'
      currentlevel--
    toc += '<li><a href="#' + @id + '">' + $(this).html() + '</a></li>\n'
    $(this).append ' <a href="#toc" class="toc_link">↑</a>'
    return
  while currentlevel > 0
    toc += '</ol>'
    currentlevel--
  $('#toc').html toc
  return


# Headline's folding function
$ ->
  $('#header_link_title').click ->
    $(this).next('ol').slideToggle()
    return
