@varbase-ai @llms-txt @recipe
Feature: The Varbase AI Readable Base recipe serves llms.txt and Markdown for AI tools
  As a Varbase site owner
  I want /llms.txt and a Markdown version of my content
  So that AI tools can read the site without parsing its HTML

  Scenario: /llms.txt lists the main and footer menus as Markdown
    Given the API base URL is ""
    When I send a GET request to "/llms.txt"
    Then the API response code should be 200
     And the response header "Content-Type" should contain "text/markdown"
     And the API response should contain "## Main navigation"
     And the API response should contain "## Footer"
     And the API response should contain "About llms.txt"

  Scenario: A page has a Markdown version at its alias with .md
    Given the API base URL is ""
    When I send a GET request to "/about-llmstxt.md"
    Then the API response code should be 200
     And the response header "Content-Type" should contain "text/markdown"
     And the API response should contain "About llms.txt"
     And the API response should not contain "<html"

  Scenario: A page answers Markdown when asked with an Accept header, and HTML otherwise
    Given the API base URL is ""
      And I set the header "Accept" to "text/markdown"
    When I send a GET request to "/about-llmstxt"
    Then the API response code should be 200
     And the response header "Content-Type" should contain "text/markdown"
    Given I am a logged in user with the "Webmaster" user
    When I navigate to "/about-llmstxt"
    Then I should see "About llms.txt"
     And I the page should not have PHP errors

  Scenario: Other .txt paths are still a fast 404
    Given the API base URL is ""
    When I send a GET request to "/nothing.txt"
    Then the API response code should be 404

  Scenario: The Webmaster can edit the llms.txt content and the Markdownify settings
    Given I am a logged in user with the "Webmaster" user
    When I navigate to "/admin/content/llms-txt"
    Then I should see "/llms.txt configuration"
     And I should see "Content of the llms.txt"
     And I the page should not have PHP errors
    When I navigate to "/admin/config/services/markdownify"
    Then I should see "Markdownify Settings"
     And I the page should not have PHP errors

  Scenario: A content editor cannot change the llms.txt content
    Given I am a logged in user with the "Content editor" user
    When I navigate to "/admin/content/llms-txt"
    Then I should not see "Content of the llms.txt"
     And I the page should not have PHP errors
