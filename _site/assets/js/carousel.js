/* global $ */

$(document).ready(function () {
  $('.carousel').slick({
    infinite: true,
    dots: true,
    autoplay: true,
    arrows: true,
    slidesToShow: 1,
    autoplaySpeed: 3000
  })
});