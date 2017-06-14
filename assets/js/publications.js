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
    var fullText = $(item).find('.btn-bibtex').data('pubBibtex').toLowerCase()
    return ~fullText.indexOf(term.toLowerCase())
  }

  items.each(function (index) {
    $(this).toggleClass('hide', !isMatch(this, searchTerm))
  })
}

// Sorting function for alphabetical author order
function sortFnAuthor (a, b) {
  var aText = $(a).data('sortKeyAuthor').toLowerCase()
  var bText = $(b).data('sortKeyAuthor').toLowerCase()
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
  var aDate = parseInt($(a).data('sortKeyDate'))
  var bDate = parseInt($(b).data('sortKeyDate'))
  return aDate - bDate
}

// Function to sort elements
function sortPublications (btnElem, sortingFn) {
  var wrapper = $('.pub-list')
  var items = wrapper.find('.pub-item')

  // Clear other sort btns
  var otherBtns = $(btnElem).siblings()
  otherBtns.find('i')
    .removeClass('fa-sort-desc')
    .removeClass('fa-sort-asc')
    .addClass('fa-sort')

  var asc = $(btnElem).find('i').hasClass('fa-sort-asc')

  if (!asc) {
    Array.prototype.sort.call(items, sortingFn)
  } else {
    Array.prototype.sort.call(items, function (a, b) {
      return sortingFn(b, a)
    })
  }

  $(btnElem).find('i')
    .removeClass('fa-sort')
    .toggleClass('fa-sort-desc', asc)
    .toggleClass('fa-sort-asc', !asc)

  wrapper.append(items)
}

function showBibtexModal (content) {
  var modalDiv = $('.modal')
  modalDiv.find('textarea').text(content)
  modalDiv.addClass('active')
  modalDiv.find('.btn-clear').click(function () {
    modalDiv.removeClass('active')
  })
  modalDiv.find('.modal-overlay').click(function () {
    modalDiv.removeClass('active')
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

  // Sort event
  $('.sort-btn-author').click(function () {
    sortPublications(this, sortFnAuthor)
  })

  $('.sort-btn-date').click(function () {
    sortPublications(this, sortFnDate)
  })

  // Open bibtex modal
  $('.btn-bibtex').click(function () {
    showBibtexModal($(this).data('pubBibtex'))
  })

  // Tag buttons
  $('.btn-tag').click(function () {
    //
  })

  // Start with recent pubs
  $('.sort-btn-date').trigger('click')
  $('.sort-btn-date').trigger('click')
})
