// Script for publications page
/* global $, Clipboard, notify */

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
      $(this).show()
    } else {
      if (Array.prototype.every.call(itemTags, function (tag) {
        return ~Array.prototype.indexOf.call(disabledTags, tag)
      })) {
        $(this).hide()
      } else if (Array.prototype.some.call(itemTags, function (tag) {
        return ~Array.prototype.indexOf.call(enabledTags, tag)
      })) {
        $(this).show()
      }
    }
  })
}

// Update document hash using currently active tags
function updateHash () {
  var enabledTags = $('.btn-tag').filter(function () {
    return $(this).hasClass('active')
  }).map(function () {
    return $(this).text().toLowerCase().replace(/ /g, '-')
  })

  document.location.hash = '#' + Array.prototype.join.call(enabledTags, '%2C')
}

$(document).ready(function () {
  var clipboard = new Clipboard('.btn')

  clipboard.on('success', function (e) {
    // Send toast notification
    notify('Copied to clipboard')
  })

  var allItems = $('.pub-item')

  // Tag buttons
  $('.btn-tag').click(function () {
    $(this).toggleClass('active')
    filterTaggedEntries(allItems)
    updateHash()
  })

  // Hash part represents the tag to start with
  var tags = document.location.hash
  if (tags !== '') {
    tags = tags.slice(1).split('%2C')
    var tagBtns = $('.btn-tag')
    var availableTags = tagBtns.map(function () {
      return $(this).text().toLowerCase().replace(/ /g, '-')
    })

    tagBtns.removeClass('active')
    tags.forEach(function (tag) {
      var tagIdx = Array.prototype.indexOf.call(availableTags, tag)
      if (tagIdx > -1) {
        tagBtns.eq(tagIdx).addClass('active')
      }
    })
    filterTaggedEntries(allItems)
  }
})
