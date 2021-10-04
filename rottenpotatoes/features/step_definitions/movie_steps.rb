# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  index = 0
  ind1 = 0
  ind2 = 0
  page.all('tbody tr').each do |tr|
    index = index + 1
    if(tr.has_content?(e1))
      ind1 = index
    end
    if(tr.has_content?(e2))
      ind2 = index
    end
    #puts(tr.inspect)
  end
  #puts(ind1)
  #puts(ind2)
  expect(ind1).to be < ind2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  arr = rating_list.split(",")
  
  for rating in arr
    
    if uncheck
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
    
  end
  
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  numMovies = page.all('tbody tr').size
  expect(numMovies).to eq Movie.count
end
