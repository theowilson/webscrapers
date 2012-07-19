require "rubygems"
gem "selenium-client"
require "selenium/client"
require 'nokogiri'
require 'csv'
require 'fastercsv'

@verification_errors = []
@selenium = Selenium::Client::Driver.new \
  :host => "localhost",
  :port => 4444,
  :browser => "*firefox3",
  :url => "https://www.boardex.com/",
  :timeout_in_second => 60

@selenium.start_new_browser_session

@selenium.open "/Login.aspx?logout=true"
@selenium.wait_for_page_to_load "30000"
@selenium.type "_txtLoginName", "HRU.KHollis"
@selenium.type "_txtPassword", "b8d3422eh"
@selenium.click "_btnLogin"
@selenium.wait_for_page_to_load "30000"
  @selenium.open("/peergroups/board/group/PeerMember.aspx?menuCat=1&pCategory=4&menuGrp=ocl&brd_peergroup_id=657606")
@selenium.wait_for_page_to_load "30000"

outfile = File.open('outfile2', 'wb')
CSV::Writer.generate(outfile) do |csv|
  csv << ["Company", "Year", "Quoted Boards To Date", "Quoted Boards Currently", "Years On Board", "Age", "Education", "SD of Years on Board", "SD of Years in Organization", "SD of Age", "SD of Education", "Gender"]
  open("companies") do |file|

    FasterCSV.parse(file.read) do |company|
      puts "Retrieving data for #{company[0]}"
      if @selenium.element?("link=#{company[0]}")    
        @selenium.click "link=#{company[0]}"
        @selenium.wait_for_page_to_load "30000"
         
        (0..3).each do |i|    
          @selenium.open("https://www.boardex.com/boards/characteristics/diversity/default.aspx?menuCat=2&pCategory=1")
            
          @selenium.wait_for_page_to_load "30000"   
            select_options = Nokogiri::HTML(@selenium.get_html_source).search('#_ctl0__ctl0_ContentPlaceholder_ContentHeaderSingleContainer_ContentHeaderTopPanel_ComparisonHeader_reportDate_ddlReportDate').search('option')
            puts select_options.count
            if select_options.count > i
              @selenium.select "_ctl0__ctl0_ContentPlaceholder_ContentHeaderSingleContainer_ContentHeaderTopPanel_ComparisonHeader_reportDate_ddlReportDate", "index=#{i}"
              # @selenium.wait_for_page_to_load "30000"       
              @selenium.open("https://www.boardex.com/boards/characteristics/diversity/default.aspx?menuCat=2&pCategory=1")
              @selenium.wait_for_page_to_load "30000"
              div_page = Nokogiri::HTML(@selenium.get_html_source)      
              # date = div_page.search('_ctl0__ctl0_ContentPlaceholder_ContentHeaderSingleContainer_ContentHeaderTopPanel_ComparisonHeader_reportDate_ddlReportDate').inner_html
              
              date= div_page.search('#_ctl0__ctl0_ContentPlaceholder_ContentHeaderSingleContainer_ContentHeaderTopPanel_ComparisonHeader_reportDate_ddlReportDate option[selected="selected"]').inner_html
              puts date
              @selenium.open("https://www.boardex.com/boards/characteristics/experience/default.aspx?menuCat=2&pCategory=1")
              @selenium.wait_for_page_to_load "30000"
              exp_page = Nokogiri::HTML(@selenium.get_html_source)
              exp_row = exp_page.search('.customGrid')[1].search('tr')[1].search('td')
              div_row = div_page.search('.customGrid')[1].search('tr')[1].search('td')      
              puts "writing row to CSV"
              csv << [company, date, exp_row[1].inner_html, exp_row[2].inner_html, exp_row[3].inner_html, exp_row[4].inner_html, exp_row[5].inner_html, div_row[1].inner_html, div_row[2].inner_html, div_row[3].inner_html, div_row[4].inner_html, div_row[5].inner_html, div_row[6].inner_html]
            else
              puts "Error for #{company[0]}, index #{i}"
            end
        end

        @selenium.open("/peergroups/board/group/PeerMember.aspx?menuCat=1&pCategory=4&menuGrp=ocl&brd_peergroup_id=657606")
        @selenium.wait_for_page_to_load "30000"
      else
        puts "Link not Found for #{company[0]}"
      end
    end
  end
end 