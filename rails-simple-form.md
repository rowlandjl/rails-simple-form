You've used Rails' built-in form helper, `form_for`, to build forms in your views. In practice, we use a gem called **Simple Form** to make building forms even easier.

### Learning Goals

* Convert forms to Simple Form
* Practice with forms

### Resources

* [Simple Form](https://github.com/plataformatec/simple_form)
* [Railscasts - Simple Form](http://railscasts.com/episodes/234-simple-form)
* [Capybara Scoping](https://github.com/jnicklas/capybara#scoping)

### Implementation Details

In this assignment, we're going to rewrite the forms in a **Restaurant** application with [Simple Form](https://github.com/plataformatec/simple_form).

#### Gettings Started

```no-highlight
# Move into the app's directory
cd rails-simple-form

# Bundle and setup like usual
bundle
rake db:drop
rake db:create
rake db:migrate

# Run all the tests and watch them pass
rspec spec
```

#### Installing Simple Form

##### Step 1 - Add the Gem to your Gemfile

Start by adding the gem to your `Gemfile`:

```ruby
gem 'simple_form'
```

Don't forget to bundle.

##### Step 2 - Generate Simple Form Install

Use the generator given to us by Simple Form to generate any of the necessary setup files.

```no-highlight
rails generate simple_form:install --foundation
```

If you are using Bootstrap or Zurb Foundation, there are special flags that can be passed to the generator to tell Simple Form to use the classes that those frameworks are expecting. You can find those in the [Readme on Github](https://github.com/plataformatec/simple_form#twitter-bootstrap).

**Now you need to restart your Rails app.**

#### The Menu Item Form

##### Removing Old Error Display

The first thing we can do is remove the part of the form that is currently responsible for displaying the errors if we fill out the form with invalid information. As you'll see in a minute, Simple Form has it's own way of displaying errors. Remove the part of the form that displays the errors.

In `app/views/menu_items/_form.html.erb`:

```erb
<div id="error_explanation">
  <h2><%= pluralize(@menu_item.errors.count, "error") %> prohibited this event from being saved:</h2>

  <ul>
  <% @menu_item.errors.full_messages.each do |msg| %>
    <li><%= msg %></li>
  <% end %>
  </ul>
</div>
```

##### Converting the Form

Simple Form gives us a replacement for the `form_for` helper that is in Rails core. The first part of the conversion is to just switch our call to `form_for` to `simple_form_for`.

In `app/views/menu_items/_form.html.erb`:

```erb
<%= simple_form_for(menu_item) do |f| %>
  <%# ... omitted ... %>
<% end %>
```

Now that we're using the `simple_form_for` helper, we can use the more simple input helpers that Simple Form gives to us.

Convert the form inputs to match. In `app/views/menu_items/_form.html.erb`:

```no-highlight
<%= simple_form_for(menu_item) do |f| %>
  <%= f.input :name %>
  <%= f.input :description %>
  <%= f.input :price_in_cents %>
  <%= f.input :category, collection: ['', 'Seafood', 'Vegetarian', 'Pasta'] %>
  <%= f.button :submit %>
<% end %>
```

#### Generated HTML

Simple Form's input helpers will generate both the `<input>` and the `<label>` for each attribute. It will also wrap the `<input>` and the `<label>` inside of a **wrapper** `<div>`.

The HTML output for the name attribute (this will be important when we update our tests):

```html
<div class="input string required menu_item_name">
  <label class="string required" for="menu_item_name">
    <abbr title="required">*</abbr> Name
  </label>
  <input aria-required="true" class="string required" id="menu_item_name" maxlength="255" name="menu_item[name]" required="required" size="255" type="text">
</div>
```

Try running the tests. Do they pass?

#### Fixing the Tests

Remember when we removed the code to display the errors? Insert a `save_and_open_page` statement in your Capybara test to inspect what the form actually looks like when you fill out the new `MenuItem` form with invalid attributes.

In `spec/features/user_adds_menu_item_spec.rb`:

```ruby
context "with invalid attributes" do
  it 'sees applicable errors' do
    visit new_menu_item_path

    click_on "Create Menu item"
    save_and_open_page

    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Description can't be blank"
    expect(page).to have_content "Price in cents can't be blank"
  end
end
```

Run the tests again and inspect the `<input>` for `name` to see how Simple Form handles displaying the errors. The HTML should look like this:

```html
<div class="input string required menu_item_name field_with_errors">
  <label class="string required" for="menu_item_name">
    <abbr title="required">*</abbr> Name
  </label>
  <input aria-required="true" class="string required" id="menu_item_name" maxlength="255" name="menu_item[name]" required="required" size="255" type="text" value="">

  <%# This is where Simple Form adds the errors for a field that failed validation %>
  <span class="error">can't be blank</span>
</div>
```

Since the errors are no longer displayed at the top of the form, and the text doesn't include their name (such as "Name can't be blank"), we need to update our tests. We can use Capybara's `within` method to [scope](https://github.com/jnicklas/capybara#scoping) our expectation to "within" a certain CSS selector (or XPATH, if you're into that).

In `spec/features/user_adds_menu_item_spec.rb`:

```ruby
context "with invalid attributes" do
  it 'sees applicable errors' do
    visit new_menu_item_path

    click_on "Create Menu item"

    within ".input.menu_item_name" do
      expect(page).to have_content "can't be blank"
    end

    within ".input.menu_item_description" do
      expect(page).to have_content "can't be blank"
    end

    within ".input.menu_item_price_in_cents" do
      expect(page).to have_content "can't be blank"
    end

    within ".input.menu_item_category" do
      expect(page).to have_content "can't be blank"
    end
  end
end
```

What we're doing is searching inside of the wrapper element for each of the inputs to find the "can't be blank" text. This lets us make sure that a specific attribute has the error without using the attribute's name in the error message.

#### Refactoring the Tests

You might have noticed that our tests are much longer now and little bit more difficult to read. Since our tests are just more Ruby code, we can write our own methods to help us write tests that are easier to read.

At the bottom of `spec/features/user_adds_menu_item_spec.rb`, we can create the following method to DRY up our tests:

```ruby
def expect_presence_error_for(attribute)
  within ".input.menu_item_#{attribute.to_s}" do
    expect(page).to have_content "can't be blank"
  end
end
```

Our new method expects you to give it an attribute and it will check the page to verify that we have an error that says "can't be blank" within the element's wrapping `<div>`.

Now we can use our new helper method to rewrite our form. In `spec/features/user_adds_menu_item_spec.rb`:

```ruby
it 'sees applicable errors' do
  visit new_menu_item_path

  click_on "Create Menu item"

  expect_presence_error_for(:name)
  expect_presence_error_for(:description)
  expect_presence_error_for(:price_in_cents)
  expect_presence_error_for(:category)
end
```

While our new test is much easier to read, we have also introduced a layer of complexity. It is important to take a minute and think. Does this test helper improve the quality of your code? Will you remember what the `expect_presence_error_for` method does in the future? Is there a better way to do this using methods provided by the Capybara gem?

#### Is it worth it?

In this case, we only have one test where we're writing all of these `within` blocks it's probably not necessary to create a helper method like this. If you found yourself doing this in multiple tests, you might then decide to extract out a helper method. For example, you will likely find yourself logging in a user in the setup for many of your test. In that case, you might want to extract a `login(user)` helper method.

**Quick Challenge**: For some extra practice, convert the `Comment` form to use Simple Form.

**Hint:** You'll need to reference the README on Github to learn how to set the label text.

### Why This is Important

#### It's simpler!

Forms can get tricky. Simple Form helps make them less tricky. Learn it and you'll love it.
