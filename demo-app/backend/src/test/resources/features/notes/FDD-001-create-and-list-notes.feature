@FDD-001
Feature: Create and list notes

  Scenario: Creating a note with title and body
    Given the user has no notes yet
    When the user creates a note with title "Shopping" and body "Milk, eggs"
    Then a note exists with title "Shopping" and body "Milk, eggs"
    And the note has an id and a creation time

  Scenario: Listing notes returns them newest first
    Given the user has no notes yet
    When the user creates a note with title "First" and body "Body one"
    And the user creates a note with title "Second" and body "Body two"
    When the user requests the list of notes
    Then the list contains 2 notes
    And the first note in the list has title "Second"
    And the second note in the list has title "First"

  Scenario: Empty title is rejected
    Given the user has no notes yet
    When the user creates a note with title "" and body "Some body"
    Then the note is rejected
    And the user has no notes
