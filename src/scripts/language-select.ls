function attach-lang-event link
  link.add-event-listener 'click', (e) ->
    e.prevent-default!
    lang = link.get-attribute 'data-lang'
    document.cookie = "eak-lang=#{lang};"
    window.location.href = link.get-attribute 'href'
  , false

function language-select
  lang = document.cookie.replace /(?:(?:^|.*;\s*)eak\-lang\s*\=\s*([^;]*).*$)|^.*$/, '$1'
  selector = document.query-selector '.lang-select'
  cover = document.query-selector '.cover'

  if lang
    window.location.href = "/#{lang}/play/#/play/cutscene/intro"
  else
    selector.class-list.add 'active'
    cover.class-list.add 'active'
    window.scroll 0, 0
    document.body.class-list.add 'no-scroll'

    for link in selector.query-selector-all 'a'
      attach-lang-event link

function setup-language
  button = document.query-selector '.demo-button'
  button.add-event-listener 'click' (e) ->
    e.prevent-default!
    language-select!
    false
  , false

setup-language!
