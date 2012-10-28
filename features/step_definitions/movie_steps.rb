# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
	 m = Movie.create!(movie) 	
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #flunk "Unimplemented"
  aBody = page.body
  #puts aBody
  aReg1 = /(.*)#{e1}(.*)/
  aReg2 = /(.*)#{e2}(.*)/  
  aRes1 = aBody =~ aReg1
  aRes2 = aBody =~ aReg2
  #puts aRes1, aRes2
  assert(aRes1 != nil && aRes2 != nil && aRes1 < aRes2, "Bad order of movies")  
  #p aBody =~ /#.*{e1}.*#{e2}/ , "Wrong order of elements"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  aList = rating_list.split(",");
  aList.each do |aRating| 
    if uncheck  
      uncheck('ratings_'+aRating);
      #page.all(:xpath,"//input[@value = '"+"ratings_"+aRating+"' and @type = 'checkbox']").each do |el|
      #   el.click
      #end
    else
      check('ratings_'+aRating);
      #page.all(:xpath,"//input[@value = '"+"ratings_"+aRating+"' and @type = 'checkbox']").each do |el|
      #  el.click
      #end
    end
  end
  #flunk "Unimplemented"
end

Then /I should (not )?see movies rated: (.*)/ do |negation, rating_list|
   
   aList = rating_list.split(",");
   ados = []
   aList.each { |s| ados << "^"+s }
   areg = /#{ados.join("|")}/i 
   puts page.all(:xpath, "//table[@id='movies']/tbody//td[2]").size
   aResult =page.all(:xpath, "//table[@id='movies']/tbody//td[2]").size > 0
   page.all(:xpath, "//table[@id='movies']/tbody//td[2]").each do |x| 
      puts negation, x.text, areg
      if negation         
         aResult = x.text =~ areg ? false : true;
      else
        aResult = x.text =~ areg ? true : false;
      end
      break if !aResult;
   end
   #puts "I should (not) see movies rated: ",page.body
   assert(aResult == true,'(not) See movies didnt passed')
   #flunk "Unimplemented"
end

When /^I (un)?check all ratings$/ do | uncheck |
  aList = Movie.all_ratings;
  aList.each do |aRating| 
    if uncheck  
      uncheck('ratings_'+aRating);
    else
      check('ratings_'+aRating);
    end
  end 
  #puts "when i"  
  #allChecks = all("input[type='checkbox']");
  #puts allChecks
  #allChecks.each do |a| 
  #  if uncheck 
  #    uncheck(a[:id])
  #    puts a[:id], a[:checked]
  #  else
  #    check(a[:id]) 
  #    puts a[:id], a[:checked]
  #  end
  #end
  #puts alist 
  #pending # express the regexp above with the code you wish you had
end

Then /I should (not )?see all movies/ do | negation |
   #tableRows = 0
   #table= page.all(:xpath, "//table[@id='movies']/tbody//tr")
   #tableRows = table.count
   c =page.body
   c1 =c.scan(/<tr>.<td>/im).size
   #puts "<<<<<<< Inicio   >>>>>>>", c, c1,"<<<<<<< FIN >>>>>>>"

   movieCount = Movie.find(:all, :conditions => ['Rating IN (?)',Movie.all_ratings]).size
   #puts tableRows, movieCount
   assert(movieCount == c1, 'Diferent values of movieCount and c1 ( #{movieCount} <-> #{c1} )',);
   #puts tableRows
end

