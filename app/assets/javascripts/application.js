// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require d3
//= require jquery
//= require jquery_ujs
//= require_tree .

document.addEventListener('DOMContentLoaded', function(){
  priceElm = document.querySelector("input.currency")
  if(priceElm != null){
    priceElm.addEventListener('input', makeCurrency)
    priceElm.value = parseFloat(priceElm.value).toFixed(2)
  }
}, false)

function makeCurrency(e){
  e.target.value = parseFloat(e.target.value).toFixed(2)
}
