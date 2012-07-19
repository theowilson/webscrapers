require 'rubygems'
require 'mechanize'
require 'csv'


#  create base csv outfile
outfile = File.open('companies', 'wb')
CSV::Writer.generate(outfile) do |csv|
  # csv << ['Company','Year', 'Quoted Boards to Date',  'Quoted Boards Currently',  'Years on Board', 'Age',  'Education',  'SD of Years on Board', 'SD of Years in Organization',  'SD of Quoted Boards to Date',  'SD of Age',  'SD of Education', 'Gender']
  agent = Mechanize.new
  puts "open browser session to the boardex login page"
  page = agent.get("https://www.boardex.com/login.aspx?ReturnUrl=/default.aspx")
  puts "login using credentials"
  login_form = page.form('Form1')
  login_form._txtLoginName = "HRU.KHollis"
  login_form._txtPassword = "b8d3422eh"
  page = agent.submit(login_form, login_form.buttons.first)
  page = agent.get("https://www.boardex.com/peergroups/board/group/PeerMember.aspx?menuCat=1&pCategory=4&menuGrp=ocl&brd_peergroup_id=657606")
  page.links_with(:href=> %r{../../../boards/summary/}).each do |link|
    begin
      agent.transact do 
        puts "Opening link #{link.uri.to_s}"
        @company = link.text
        csv << [@company]
        link.click
         div_page = agent.get("https://www.boardex.com/boards/characteristics/diversity/default.aspx?menuCat=2&pCategory=1")
         div_select_list = div_page.search('#_ctl0__ctl0_ContentPlaceholder_ContentHeaderSingleContainer_ContentHeaderTopPanel_ComparisonHeader_reportDate_ddlReportDate').search('option')
         exp_page = agent.get("https://www.boardex.com/boards/characteristics/diversity/default.aspx?menuCat=2&pCategory=1")
         exp_select_list = exp_page.search('#_ctl0__ctl0_ContentPlaceholder_ContentHeaderSingleContainer_ContentHeaderTopPanel_ComparisonHeader_reportDate_ddlReportDate').search('option')                            
         (0..4).each do |i|
           @year = 2010-i
           if div_select_list.count > i
             div_select_list[i].select
             div_row = div_page.search('.customGrid')[1].search('tr')[1].search('td')
             div_select_list[i].select            
             exp_row = exp_page.search('.customGrid')[1].search('tr')[1].search('td')
             csv << [@company, @year, exp_row[1].inner_html, exp_row[2].inner_html, exp_row[3].inner_html, exp_row[4].inner_html, exp_row[5].inner_html, div_row[1].inner_html, div_row[2].inner_html, div_row[3].inner_html, div_row[4].inner_html, div_row[5].inner_html, div_row[5].inner_html ]
           end
         end  
       end 
     end
  end
end
outfile.close