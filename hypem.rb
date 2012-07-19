require 'rubygems'
require 'watir-webdriver'
require 'paperclip'
require 'open-uri'

USERNAME = "tawilson"

SOURCE_URL = 'http://hypem.com'

urlList = []

browser = Watir::Browser.new
browser.goto SOURCE_URL + "/" + USERNAME

# set key
browser.execute_script "jQuery('body').append('<div id=auth_cookie>'+get_cookie('AUTH')+'</div>')"
browser.execute_script("
var auth_cookie = jQuery('#auth_cookie').text();
set_cookie('AUTH', auth_cookie, 10, 'http://hypem.com', '/', false)
")
until browser.links(:class => "next").length < 1 do
  browser.execute_script("
  var tracks = trackList[document.location.href];
  jQuery('ul.tools').each(function(index, track) {
  var songUrl = '/serve/play/'+tracks[index].id+'/';
  songUrl += tracks[index].key;
  songUrl += '.mp3';
  songClass = 'downloadLink';
  jQuery('body').append('<div class=' + songClass + '>' + songUrl + '</ div>');
  });
  ")
  browser.divs(:class => "downloadLink").each do |link|
    urlList << SOURCE_URL + link.text
  end
  browser.goto browser.links(:class => "next").first.href
end
puts urlList