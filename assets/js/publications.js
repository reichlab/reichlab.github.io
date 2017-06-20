// Script for publications page
/* global $, Clipboard */

// Return number of visible entries
function nShown (items) {
  var n = 0
  items.each(function () {
    if (!($(this).hasClass('hide') || $(this).hasClass('bib-disabled'))) n++
  })
  return n
}

// Filter displayed entries
function filterEntries (items, searchTerm) {
  function isMatch (item, term) {
    var fullText = $(item).find('.btn-bibtex').data('pubBibtex').toLowerCase()
    return ~fullText.indexOf(term.toLowerCase())
  }

  items.each(function () {
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

// Function to actually sort elements
function sortPublications (items, btnElem, sortingFn) {
  var wrapper = $('.pub-list')

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

// Filter all entries according to current selection state of tags
function filterTaggedEntries (items) {
  var enabledTags = $('.btn-tag').filter(function () {
    return $(this).hasClass('active')
  }).map(function () {
    return $(this).text().toLowerCase()
  })

  var disabledTags = $('.btn-tag').filter(function () {
    return !$(this).hasClass('active')
  }).map(function () {
    return $(this).text().toLowerCase()
  })

  // if all tags are disabled, disable entry
  // if any tag is enabled, enable entry
  items.each(function () {
    var itemTags = $(this).find('.pub-tag').map(function () {
      return $(this).text().toLowerCase()
    })

    if (itemTags.length === 0) {
      $(this).removeClass('bib-disabled')
    } else {
      if (Array.prototype.every.call(itemTags, function (tag) {
        return ~Array.prototype.indexOf.call(disabledTags, tag)
      })) {
        $(this).addClass('bib-disabled')
      } else if (Array.prototype.some.call(itemTags, function (tag) {
        return ~Array.prototype.indexOf.call(enabledTags, tag)
      })) {
        $(this).removeClass('bib-disabled')
      }
    }
  })
}

// Refresh hint text below the search input specifyin number of items displayed
function refreshDisplayedText (items) {
  $('.search-results').text(nShown(items) + ' of ' + items.length + ' publications displayed')
}

$(document).ready(function () {
  var clipboard = new Clipboard('.btn')

  clipboard.on('success', function (e) {
    // Send toast notification
    notify('Copied to clipboard')
  })

  var allItems = $('.pub-item')
  refreshDisplayedText(allItems)

  // Handle event on filter input
  $('.filter-input').keyup(function () {
    var searchTerm = $(this).val()
    filterEntries(allItems, searchTerm)
    refreshDisplayedText(allItems)
  })

  // Sort event
  $('.sort-btn-author').click(function () {
    sortPublications(allItems, this, sortFnAuthor)
  })

  $('.sort-btn-date').click(function () {
    sortPublications(allItems, this, sortFnDate)
  })

  // Tag buttons
  $('.btn-tag').click(function () {
    $(this).toggleClass('active')
    filterTaggedEntries(allItems)
    refreshDisplayedText(allItems)
  })

  // Start with recent pubs
  $('.sort-btn-date').trigger('click')
  $('.sort-btn-date').trigger('click')
})
