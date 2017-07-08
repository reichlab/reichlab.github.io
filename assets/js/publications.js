// Script for publications page
/* global $ */

// Filter all entries according to current selection state of keywords
function filterKeywordEntries (items) {
  var enabledKeywords = $('.btn-keyword').filter(function () {
    return $(this).hasClass('active')
  }).map(function () {
    return $(this).text().toLowerCase()
  })

  var disabledKeywords = $('.btn-keyword').filter(function () {
    return !$(this).hasClass('active')
  }).map(function () {
    return $(this).text().toLowerCase()
  })

  // if all keywords are disabled, disable entry
  // if any keyword is enabled, enable entry
  items.each(function () {
    var itemKeywords = $(this).find('.pub-keyword').map(function () {
      return $(this).text().toLowerCase()
    })

    if (itemKeywords.length === 0) {
      $(this).show()
    } else {
      if (Array.prototype.every.call(itemKeywords, function (keyword) {
        return ~Array.prototype.indexOf.call(disabledKeywords, keyword)
      })) {
        $(this).hide()
      } else if (Array.prototype.some.call(itemKeywords, function (keyword) {
        return ~Array.prototype.indexOf.call(enabledKeywords, keyword)
      })) {
        $(this).show()
      }
    }
  })

  filterYearEntries()
}

// Show/hide year text depending on visibility states of its group items
function filterYearEntries () {
  $('.pub-year').each(function () {
    var children = $(this).closest('.pub-list').find('.pub-item')
    $(this).toggle(Array.prototype.some.call(children, function (child) {
      return $(child).is(':visible')
    }))
  })
}

function serializeKeywords (keywords) {
  return 'keywords=' + Array.prototype.join.call(keywords, ',')
}

function serializePub (pub) {
  return 'pub=' + pub
}

function dumpHash (items) {
  document.location.hash = '#' + Array.prototype.join.call(items, '&')
}

// Update document hash using currently active keywords
function updateHashKeywords () {
  var enabledKeywords = $('.btn-keyword').filter(function () {
    return $(this).hasClass('active')
  }).map(function () {
    return $(this).text().toLowerCase().replace(/ /g, '-')
  })

  var hashItems = []
  if (enabledKeywords.length > 0) {
    hashItems.push(serializeKeywords(enabledKeywords))
  }
  var currentHash = parseHash(document.location.hash)
  if (currentHash.pub) {
    hashItems.push(serializePub(currentHash.pub))
  }
  dumpHash(hashItems)
}

// Update link of current paper in hash
function updateHashPub (pubItem) {
  var currentHash = parseHash(document.location.hash)
  var hashItems = [serializePub(pubItem.attr('id'))]
  if (currentHash.keywords) {
    hashItems.push(serializeKeywords(currentHash.keywords))
  }
  dumpHash(hashItems)
}

// Toggle hash
function togglePubAbstract (pubItem) {
  pubItem.find('.pub-abstract').toggle(200)
}

// Parse data from hash string
function parseHash (hash) {
  var hashText = hash.substr(1)
  var output = {}
  if (hashText.length > 0) {
    var items = hashText.split('&')
    items.forEach(function (it) {
      var key = it.split('=')[0]
      var value = it.split('=')[1].split(',')

      // Keyword is the only plural thing here
      if (key !== 'keywords') {
        value = value[0]
      }
      output[key] = value
    })
  }

  return output
}

$(document).ready(function () {
  var allItems = $('.pub-item')

  // Show all / none buttons
  $('.btn-keyword-all').click(function () {
    $('.btn-keyword').addClass('active')
    filterKeywordEntries(allItems)
    updateHashKeywords()
  })

  $('.btn-keyword-none').click(function () {
    $('.btn-keyword').removeClass('active')
    filterKeywordEntries(allItems)
    updateHashKeywords()
  })

  // Keyword buttons
  $('.btn-keyword').click(function () {
    $(this).toggleClass('active')
    filterKeywordEntries(allItems)
    updateHashKeywords()
  })

  // Read hash
  var hash = parseHash(document.location.hash)

  // Filter keywords if specified
  if (hash.keywords) {
    var keywordBtns = $('.btn-keyword')
    var availableKeywords = keywordBtns.map(function () {
      return $(this).text().toLowerCase().replace(/ /g, '-')
    })

    keywordBtns.removeClass('active')
    hash.keywords.forEach(function (keyword) {
      var keywordIdx = Array.prototype.indexOf.call(availableKeywords, keyword)
      if (keywordIdx > -1) {
        keywordBtns.eq(keywordIdx).addClass('active')
      }
    })
    filterKeywordEntries(allItems)
  }

  // Scroll to pub and open abstract if specified
  if (hash.pub) {
    var pubItem = $('#' + hash.pub)
    $(window).scrollTop(pubItem.offset().top)
    togglePubAbstract(pubItem)
  }

  // Show abstract on click
  $('.pub-title').click(function (e) {
    e.preventDefault()
    togglePubAbstract($(this).closest('.pub-item'))
    updateHashPub($(this).closest('.pub-item'))
  })

  $('.pub-image').click(function (e) {
    e.preventDefault()
    togglePubAbstract($(this).closest('.pub-item'))
    updateHashPub($(this).closest('.pub-item'))
  })
})
