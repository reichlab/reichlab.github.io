// Script for publications page
/* global $ */

// Return number of displayed entries
function nShown (items) {
  var n = 0
  items.each(function (index) {
    if (!$(this).hasClass('hide')) n++
  })
  return n
}

// Filter displayed entries
function filterEntries (items, searchTerm) {
  function isMatch (item, term) {
    var fullText = $(item).find('.pub-bibtex').text().toLowerCase()
    return ~fullText.indexOf(term.toLowerCase())
  }

  items.each(function (index) {
    $(this).toggleClass('hide', !isMatch(this, searchTerm))
  })
}

$(document).ready(function () {
  var allPubs = $('.pub-item')
  $('.search-results').text(nShown(allPubs) + ' of ' + allPubs.length + ' publications displayed')

  // Handle event on filter input
  $('.filter-input').keyup(function () {
    var searchTerm = $(this).val()
    filterEntries(allPubs, searchTerm)
    $('.search-results').text(nShown(allPubs) + ' of ' + allPubs.length + ' publications displayed')
  })
})
