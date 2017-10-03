# require 'rubygems'
require 'capybara'
# require 'poltergeist'
require 'capybara/poltergeist'
# require 'concurrent'
# require 'open-uri'
require 'phantomjs'
require 'mechanize'
require 'nokogiri'


    Capybara.register_driver(:poltergeist) { |app| Capybara::Poltergeist::Driver.new(app, js_errors: false, debug: false, phantomjs_options: ['--load-images=false', '--disk-cache=false'] ) }
    Capybara.default_driver = :poltergeist

    page = Capybara.current_session     # the object we'll interact with
    page.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9A334 Safari/7534.48.3' }

    # page.driver.browser.url_blacklist = [ 'https://www.enterprise.com/etc/designs/ecom/dist/fonts/', 'https://cdnssl.clicktale.net', 'https://static.ads-twitter.com', 'https://developers.google.com', 'https://maps.googleapis.com', 'https://www.googleadservices.com']
    # page.driver.browser.url_whitelist = ['https://enterprise.com']
    
    url = 'https://www.avis.com/en/locations/us/ca/oceanside/ocn'

    page.visit url
    # puts page.driver.network_traffic.inspect

    Capybara.using_wait_time(120) { page.body.include?('Select My Car') }

    element = page.find('input[id=from]').click
    # sleep(0.1)
    element.native.send_key('12/01/2017')
    # sleep(0.1)
    element = page.find('input[id=to]')
    element.click
    # sleep(0.1)
    element.native.send_key('12/03/2017')
    # sleep(0.1)
    page.find('div[title="Discount Codes"]').click
    # sleep(0.1)
    page.find('input[id=awd]').native.send_key('A359807')
    # sleep(0.1)
    puts "awd entered"
    # page.find('input[id=coupon]').native.send_key('A359807')
    # sleep(0.1)
    page.find('button[id="res-home-select-car"]').click
  

    # Capybara.using_wait_time(120) { page.body.include?('currency') }
    while !page.body.include?('currency') do 
        # puts "loading results"
    end
    # sleep(0.1)
    puts page.body

    noko = Nokogiri::HTML(page.body)

    results = []
    noko.css('.available-car-box').each do |div|
        attrs = {}
        # puts div.css('h3')[0].text
        # puts div.css('p.payamntr')[0].text
        # puts div.css('p.similar-car')[0].text.strip.chomp(" or Similar")


        klass = div.css('h3')[0].text.to_sym

        attrs[:class] = div.css('h3')[0].text
        attrs[:amount] = div.css('p.payamntr')[0].text.gsub('$', '')
        attrs[:car] = div.css('p.similar-car')[0].text.strip.chomp(" or Similar")



        results << attrs
    end

    puts results.inspect

    # divs = noko.xpath('//div[@ng-bind="row avilablecar available-car-box"]')
    # noko.at_css("[class='row avilablecar available-car-box']")[0]

    # divs = noko.css(".row avilablecar available-car-box")

    # puts divs.inspect







