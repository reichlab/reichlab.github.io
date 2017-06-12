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

// Sorting function for alphabetical author order
function sortFnAuthor (a, b) {
  let aText = $(a).find('.sort-key-author').text().toLowerCase()
  let bText = $(b).find('.sort-key-author').text().toLowerCase()
  if (aText < bText) {
    return -1
  }
  if (bText < aText) {
    return 1
  }
  return 0
}

// Sorting function for sorting by date
function sortFnDate (a, b) {
  let aDate = parseInt($(a).find('.sort-key-date').text())
  let bDate = parseInt($(b).find('.sort-key-date').text())
  return aDate - bDate
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

  // Sort event
  $('.sort-btn-author').click(function () {
    let wrapper = $('.pub-list')
    let items = wrapper.find('.pub-item')
    Array.prototype.sort.call(items, sortFnAuthor)
    wrapper.append(items)
  })

  $('.sort-btn-date').click(function () {
    let wrapper = $('.pub-list')
    let items = wrapper.find('.pub-item')
    Array.prototype.sort.call(items, sortFnDate)
    wrapper.append(items)
  })
})
