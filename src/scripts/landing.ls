cover = document.query-selector '.cover'
form = document.query-selector '#signup'

function show-form
  cover.class-list.add 'active'
  form.class-list.add 'active'

function hide-form
  cover.class-list.remove 'active'
  form.class-list.remove 'active'

function check-hash hash
  if hash.match /signup/
    show-form!
  else
    hide-form!

function setup
  window.add-event-listener \hashchange ->
    check-hash window.location.hash
  , false

  check-hash window.location.hash

setup!
