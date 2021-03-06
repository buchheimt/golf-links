# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Recipes)
        *-Course has_many TeeTimes*
- [x] Include at least one belongs_to relationship (x belongs_to y e.g. Post belongs_to User)
        *-TeeTime belongs to Course*
- [x] Include at least one has_many through relationship (x has_many y through z e.g. Recipe has_many Items through Ingredients)
        *User has_many TeeTimes through UserTeeTimes*
- [x] The "through" part of the has_many through includes at least one user submittable attribute (attribute_name e.g. ingredients.quantity)
        *-user_tee_times.guest_count*
- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
        *-User, Course, TeeTime, UserTeeTime*
- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
        *-Course.most_popular: /courses/most_popular*
- [x] Include a nested form writing to an associated model using a custom attribute writer (form URL, model name e.g. /recipe/new, Item)
        *-/tee_times/new, UserTeeTime*
- [x] Include signup (how e.g. Devise) *-Custom authentication system with bcrypt and omniauth/facebook*
- [x] Include login (how e.g. Devise) *-Custom authentication system with bcrypt and omniauth/facebook*
- [x] Include logout (how e.g. Devise) *-Custom authentication system with bcrypt and omniauth/facebook*
- [x] Include third party signup/login (how e.g. Devise/OmniAuth) *-omniauth/omniauth-facebook*
- [x] Include nested resource show or index (URL e.g. users/2/recipes)
        *-/users/2/tee_times*
- [x] Include nested resource "new" form (URL e.g. recipes/1/ingredients)
        *-/courses/1/tee_times/new*
- [x] Include form display of validation errors (form URL e.g. /recipes/new)
        *-/users/new*

Confirm:
- [x] The application is pretty DRY
- [x] Limited logic in controllers
- [x] Views use helper methods if appropriate
- [x] Views use partials if appropriate
