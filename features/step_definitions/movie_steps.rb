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
  puts aBody 
  p aBody =~ /#.*{e1}.*#{e2}/ , "Wrong order of elements"
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
    else
      check('ratings_'+aRating);
    end
  end
  #flunk "Unimplemented"
end

Then /I should (not )?see movies rated: (.*)/ do |negation, rating_list|
   aResult = true;
   aList = rating_list.split(",");
   ados = []
	aList.each { |s| ados << "^"+s }
	areg = /#{ados.join("|")}/i 

   page.all(:xpath, "//table[@id='movies']/tbody//td[2]").each do |x| 
      if negation         
			aResult = x.text =~ areg ? false : true;
		else
        aResult = x.text =~ areg ? true : false;
      end
      break if !aResult;
   end
   assert(aResult == true,'no passed')
   #flunk "Unimplemented"
end

When /^I (un)?check all rattings$/ do | uncheck | 
  #puts "when i"  
  all("input[type='checkbox']").each do |a| 
    if uncheck 
      uncheck(a[:id])
      puts a[:id], a[:checked]
    else
      check(a[:id]) 
		puts a[:id], a[:checked]
    end
  end

  #puts alist 
  #pending # express the regexp above with the code you wish you had
end

Then /I should (not )?see all movies/ do | negation |
   tableRows = 0
#= page.all(:xpath, "//table[@id='movies']/tbody//td[2]").count
   page.all(:xpath, "//table[@id=\"movies\"]/tbody//td[2]").each do |row| 
     tableRows = tableRows + 1 
     puts tableRows
   end
   #puts x, x.count
   movieCount = Movie.find(:all, :conditions => ['Rating IN (?)',Movie.all_ratings]).size
   puts tableRows, movieCount
   assert(movieCount == tableRows, 'failed');
   #puts tableRows
end

