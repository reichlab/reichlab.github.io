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
  })

  // Hash part represents the tag to start with
  var tag = document.location.hash
  if (tag !== '') {
    tag = tag.slice(1)
    var tagBtns = $('.btn-tag')
    var availableTags = tagBtns.map(function () {
      return $(this).text().toLowerCase().replace(/ /g, '-')
    })

    var tagIdx = Array.prototype.indexOf.call(availableTags, tag)
    if (tagIdx > -1) {
      tagBtns.trigger('click')
      tagBtns.eq(tagIdx).trigger('click')
    }
  }
})
