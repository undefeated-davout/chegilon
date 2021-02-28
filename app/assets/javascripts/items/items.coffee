# Twitter tweet button
!((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  p = if /^http:/.test(d.location) then 'http' else 'https'
  if !d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = p + '://platform.twitter.com/widgets.js'
    fjs.parentNode.insertBefore js, fjs
  return
)(document, 'script', 'twitter-wjs')


# Facebook share & like button
((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  if d.getElementById(id)
    return
  js = d.createElement(s)
  js.id = id
  js.src = '//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.9'
  fjs.parentNode.insertBefore js, fjs
  return
) document, 'script', 'facebook-jssdk'


# Item's realtime preview proccess
$ ->
# 入力補助ボタンイベント
  $('#button_bold').click ->
    input_assist "太字", "**", "**"
  $('#button_italic').click ->
    input_assist "イタリック", "_", "_"
  $('#button_header').click ->
    input_assist "見出し", "###", ""
  $('#button_link').click ->
    input_assist "http://", "[リンク内容](", ")"
  $('#button_picture').click ->
    input_assist "http://", "![イメージ説明](", ")"
  $('#button_quote').click ->
    input_assist "引用", ">", ""
  $('#button_ul').click ->
    input_assist "リスト", "- ", ""
  $('#button_ol').click ->
    input_assist "リスト", "0. ", ""
  $('#button_horizon').click ->
    input_assist "", "\r\n---\r\n", ""

  # Input support method
  input_assist = (explain_text, start_text, end_text, new_line_flg) ->
    if typeof new_line_flg == 'undefined'
      new_line_flg = false
    if $('#item_content').selection()
      $('#item_content').selection('replace', {text: end_text + $('#item_content').selection() + end_text})
    else
      if new_line_flg
        $('#item_content').selection('replace', {text: "\r\n" + start_text + "\r\n" + explain_text + "\r\n" + end_text})
      else
        $('#item_content').selection('replace', {text: start_text + explain_text + end_text})
    str_len = $('#item_content').selection('get').length
    pos_start = $('#item_content').selection('getPos').start
    if str_len == 0
      str_len = explain_text.length + start_text.length + end_text.length
    if new_line_flg
      $('#item_content').selection('setPos', {
        start: pos_start + 2 + start_text.length,
        end: pos_start + str_len - end_text.length - 1
      })
    else
      $('#item_content').selection('setPos', {
        start: pos_start + start_text.length,
        end: pos_start + str_len - end_text.length
      })
    update_preview($('#item_content').val())
    return

  update_preview = (text) ->
    $.ajax
      async: false
      url: '/api_markdown'
      type: 'POST'
      data: {text: text}
      success: (data) ->
        $('#preview').html(data)
        return
      error: (xhr, status, err) ->
        $('#preview').html 'エラー発生 ' + err
        return

  timer = false
  $('#item_content').on 'keyup', ->
    if timer != false
      clearTimeout timer
    timer = setTimeout((->
      update_preview($('#item_content').val())
    ), 400)
    return


# Tag's auto complete, and tag setting on edit
$(document).on 'ready page:load', ->
  $('#item-tags').tagit
    placeholderText: 'タグを入力します・・・'
    fieldName: 'item[tag_list]'
    singleField: true
    availableTags: gon.available_tags
    preprocessTag: (val) ->
      val.replace(/\(\d+\)/g, "") # Remove tag's count display
  if gon.item_tags?
    for tag in gon.item_tags
      $('#item-tags').tagit 'createTag', tag


# Histories folding function
$ ->
  $('.comment_area').click ->
    $(this).next('.item_info').slideToggle()
    return


# 入力フォームとプレビューのスクロール位置の同期
# Input form and preview's scroll synchronism function
$ ->
  $('#item_content').scroll ->
    form_scrolltop = $('#item_content').scrollTop()
    form_height = $('#item_content').height()
    preview_height = $('.col-sm-6').height()
    preview_scrolltop = form_scrolltop * (preview_height / form_height)
    $('.col-sm-6').scrollTop preview_scrolltop
    return


$ ->
# #で始まるアンカーをクリックした場合に処理
  $('.item_show a').click ->
# スクロールの速度
    speed = 400
    # ミリ秒
    # アンカーの値取得
    href = $(this).attr('href')
    # 移動先を取得
    target = $(if href == '#' or href == '' then 'html' else href)
    # 移動先のズレを調整
    top_adjust = 90
    # 移動先を数値で取得
    position = target.offset().top - top_adjust
    # スムーススクロール
    $('body,html').animate {scrollTop: position}, speed, 'swing'
    false
  return
