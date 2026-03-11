package com.demo.notes.steps;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.spring.CucumberContextConfiguration;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;

import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

@CucumberContextConfiguration
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class NoteSteps {

    @LocalServerPort
    private int port;

    private Response lastResponse;

    @DynamicPropertySource
    static void configure(DynamicPropertyRegistry registry) {
        registry.add("spring.jpa.hibernate.ddl-auto", () -> "create-drop");
    }

    @Given("the user has no notes yet")
    public void the_user_has_no_notes_yet() {
        RestAssured.port = port;
        RestAssured.baseURI = "http://localhost";
        // For a clean state we rely on create-drop; or DELETE all (if we had an endpoint)
    }

    @When("the user creates a note with title {string} and body {string}")
    public void the_user_creates_a_note_with_title_and_body(String title, String body) {
        lastResponse = given()
                .contentType(ContentType.JSON)
                .body(Map.of("title", title, "body", body))
                .when()
                .post("/api/v1/notes");
    }

    @Then("a note exists with title {string} and body {string}")
    public void a_note_exists_with_title_and_body(String title, String body) {
        lastResponse.then().statusCode(201)
                .body("title", equalTo(title))
                .body("body", equalTo(body));
    }

    @Then("the note has an id and a creation time")
    public void the_note_has_an_id_and_a_creation_time() {
        lastResponse.then()
                .body("id", notNullValue())
                .body("createdAt", notNullValue());
    }

    @When("the user requests the list of notes")
    public void the_user_requests_the_list_of_notes() {
        lastResponse = given().when().get("/api/v1/notes");
    }

    @Then("the list contains {int} notes")
    public void the_list_contains_notes(int count) {
        lastResponse.then().statusCode(200)
                .body("size()", equalTo(count));
    }

    @Then("the first note in the list has title {string}")
    public void the_first_note_in_the_list_has_title(String title) {
        lastResponse.then().body("[0].title", equalTo(title));
    }

    @Then("the second note in the list has title {string}")
    public void the_second_note_in_the_list_has_title(String title) {
        lastResponse.then().body("[1].title", equalTo(title));
    }

    @Then("the note is rejected")
    public void the_note_is_rejected() {
        lastResponse.then().statusCode(400);
    }

    @Then("the user has no notes")
    public void the_user_has_no_notes() {
        lastResponse = given().when().get("/api/v1/notes");
        lastResponse.then().statusCode(200).body("size()", equalTo(0));
    }
}
