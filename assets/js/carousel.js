/* global $ */

$(document).ready(function () {
  $('.carousel').slick({
    lazyLoad: 'ondemand',
    infinite: true,
    dots: true,
    autoplay: true,
    autoplaySpeed: 3000
  })
})
