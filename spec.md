# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Recipes)
        *-Several has_many relationships, i.e. Users have many Tee Times*
- [x] Include at least one belongs_to relationship (x belongs_to y e.g. Post belongs_to User)
        *-A Tee Time belongs to a course, as well as the user_tee_times join table*
- [x] Include at least one has_many through relationship (x has_many y through z e.g. Recipe has_many Items through Ingredients)
        *-Several has_many relationships, i.e. Users have many Courses and vice versa*
- [x] The "through" part of the has_many through includes at least one user submittable attribute (attribute_name e.g. ingredients.quantity)
        *-User can create a course with basic attributes through the new tee time form (name, description, location)*
- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
        *-Models have varying levels of validations, User being the most strict*
- [ ] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
- [x] Include a nested form writing to an associated model using a custom attribute writer (form URL, model name e.g. /recipe/new, Item)
- [x] Include signup (how e.g. Devise) *-Custom authentication system implemented*
- [x] Include login (how e.g. Devise) *-Custom authentication system implemented*
- [x] Include logout (how e.g. Devise) *-Custom authentication system implemented*
- [x] Include third party signup/login (how e.g. Devise/OmniAuth) *-Facebook*
- [x] Include nested resource show or index (URL e.g. users/2/recipes)
        *-Tee Times are nested in users and courses*
- [x] Include nested resource "new" form (URL e.g. recipes/1/ingredients)
        *-user/:id/tee_times/new for Users to create new tee times*
- [x] Include form display of validation errors (form URL e.g. /recipes/new)
        *-forms show validation errors next to proper field with styling*

Confirm:
- [ ] The application is pretty DRY
- [ ] Limited logic in controllers
- [ ] Views use helper methods if appropriate
- [ ] Views use partials if appropriate
