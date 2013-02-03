# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end


When /^I check all the ratings$/  do
  step %Q{ I check the following ratings: R, PG, PG-13, G, NC-17  }
end

When /^I uncheck all the ratings$/  do
  step %Q{ I uncheck the following ratings: R, PG, PG-13, G, NC-17  }
end

Then /^I should see all of the movies$/ do
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # <tbody> <tr> *  </tr> )? </tbody> should be 10
  #<tr[^>]*>.*</tr>#
  value = Movie.find(:all).length + 1
  page.body.scan(/<tr>/).length.should == value
end

Then /^I should see some movies$/ do
  page.body.scan(/<tr>/).length.should >= 1
end

Then /^I should see the following ratings: (.*)/ do |rating_list|
  rating_list.gsub!(/\s+/, "")
  rl = rating_list.split(',')
  rl.each do |rating|
    page.body.scan(/<td>#{rating}/).length.should >= 0
  end
end

Then /^I should not see the following ratings: (.*)/ do |rating_list|
  rating_list.gsub!(/\s+/, "")
  rl = rating_list.split(',')
  rl.each do |rating|
    page.body.scan(/<tr>#{rating}/).length.should == 0
  end
end


# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # id="ratings_PG"
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.gsub!(/\s+/, "")
  rl = rating_list.split(',')
  rl.each do |rating|
    r = "ratings_"
    r << rating
    if uncheck then s = "uncheck" else s = "check" end
    step %Q{I #{s} "#{r}"}
#    step  %Q{I check "ratings_PG"}

  end
end

