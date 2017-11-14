# Specifications for the Rails with jQuery Assessment

Specs:
- [x] Use jQuery for implementing new requirements
- [x] Include a show resource rendered using jQuery and an Active Model Serialization JSON backend.
        *-Course#show routes can cycle via 'Next' and 'Prev' via AJAX*
- [x] Include an index resource rendered using jQuery and an Active Model Serialization JSON backend.
        *-TeeTime#index page can be filtered via AJAX requests*
- [x] Include at least one has_many relationship in information rendered via JSON and appended to the DOM.
        *-Course has many TeeTimes and TeeTimes are loaded and appended to DOM via AJAX when 'Next' or 'Prev' is clicked*
- [x] Use your Rails API and a form to create a resource and render the response without a page refresh.
        *-Comments are created and added to TeeTime#show DOM via AJAX*
- [x] Translate JSON responses into js model objects.
        *-Comment class converts JSON into comment object*
- [x] At least one of the js model objects must have at least one method added by your code to the prototype.
        *-Comment class has prototype method #renderDiv*

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
