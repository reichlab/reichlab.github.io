// Add toast functions
/* globals $ */

function notify (text) {
  $('.toast').show(100)
    .find('.toast-text').text(text)

  setTimeout(function () {
    $('.toast').hide(100)
  }, 2000)
}
