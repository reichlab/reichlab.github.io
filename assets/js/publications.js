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
  var aText = $(a).find('.sort-key-author').text().toLowerCase()
  var bText = $(b).find('.sort-key-author').text().toLowerCase()
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
  var aDate = parseInt($(a).find('.sort-key-date').text())
  var bDate = parseInt($(b).find('.sort-key-date').text())
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
    var wrapper = $('.pub-list')
    var items = wrapper.find('.pub-item')

    var asc = $(this).find('i').hasClass('fa-sort-asc')

    if (!asc) {
      Array.prototype.sort.call(items, sortFnAuthor)
      $(this).find('i').removeClass('fa-sort')
      $(this).find('i').removeClass('fa-sort-desc')
      $(this).find('i').addClass('fa-sort-asc')
    } else {
      Array.prototype.sort.call(items, function (a, b) {
        return sortFnAuthor(b, a)
      })
      $(this).find('i').removeClass('fa-sort')
      $(this).find('i').removeClass('fa-sort-asc')
      $(this).find('i').addClass('fa-sort-desc')
    }

    wrapper.append(items)
  })

  $('.sort-btn-date').click(function () {
    var wrapper = $('.pub-list')
    var items = wrapper.find('.pub-item')

    var asc = $(this).find('i').hasClass('fa-sort-asc')

    if (!asc) {
      Array.prototype.sort.call(items, sortFnDate)
      $(this).find('i').removeClass('fa-sort')
      $(this).find('i').removeClass('fa-sort-desc')
      $(this).find('i').addClass('fa-sort-asc')
    } else {
      Array.prototype.sort.call(items, function (a, b) {
        return sortFnDate(b, a)
      })
      $(this).find('i').removeClass('fa-sort')
      $(this).find('i').removeClass('fa-sort-asc')
      $(this).find('i').addClass('fa-sort-desc')
    }

    wrapper.append(items)
  })

  // Start with recent pubs
  $('.sort-btn-date').trigger('click')
  $('.sort-btn-date').trigger('click')
})
