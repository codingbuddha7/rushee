---
name: atdd-acceptance-first
description: >
  This skill should be used after Gherkin feature files are written and confirmed. 
  Triggers on: "generate step definitions", "wire up cucumber", "run acceptance tests",
  "ATDD", "make the feature file executable", or automatically after bdd-gherkin-spec completes.
  Also triggers if a developer attempts to write implementation code before step definitions exist.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

# ATDD — Acceptance Test First Skill

## Purpose
Transform confirmed Gherkin `.feature` files into a FAILING acceptance test suite.
The tests MUST be red before any implementation begins. This is not optional.

## The Two-Stream Rule (Uncle Bob)
Every feature needs TWO test streams running simultaneously:
1. **Outer stream** — Cucumber acceptance tests (verify WHAT the system does)
2. **Inner stream** — JUnit/Mockito unit tests (verify HOW each class behaves)

Neither stream alone is sufficient. The outer stream without the inner produces working-but-fragile code. The inner stream without the outer produces well-structured-but-wrong code.

## Mandatory Gate — STOP if violated
**Step 1 is ALWAYS: run the feature file and confirm RED.**
If the acceptance test is not failing, something is wrong — either the test is already implemented (skip the step) or the test is not actually running.

Red Flags:
- Writing ANY service/controller/repository code before acceptance tests are RED
- Writing step definitions that call non-existent code and skipping the RED phase
- Marking `@Pending` on scenarios and moving on
- "I'll wire up the acceptance tests after the implementation"

## Step 1 — Set Up Cucumber in the Spring Project

### Maven dependencies to add to `pom.xml` if not present:
```xml
<!-- Cucumber BDD Testing -->
<dependency>
  <groupId>io.cucumber</groupId>
  <artifactId>cucumber-spring</artifactId>
  <version>${cucumber.version}</version>
  <scope>test</scope>
</dependency>
<dependency>
  <groupId>io.cucumber</groupId>
  <artifactId>cucumber-junit-platform-engine</artifactId>
  <version>${cucumber.version}</version>
  <scope>test</scope>
</dependency>
<dependency>
  <groupId>org.junit.platform</groupId>
  <artifactId>junit-platform-suite</artifactId>
  <scope>test</scope>
</dependency>
<!-- REST testing for API acceptance tests -->
<dependency>
  <groupId>io.rest-assured</groupId>
  <artifactId>rest-assured</artifactId>
  <scope>test</scope>
</dependency>
```

### Cucumber runner (create if missing):
```java
// src/test/java/<base-package>/CucumberIT.java
@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "<base-package>.steps")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "pretty, html:target/cucumber-reports/report.html")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class CucumberIT {}
```

### Spring context for steps:
```java
// src/test/java/<base-package>/steps/CucumberSpringContext.java
@CucumberContextConfiguration
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class CucumberSpringContext {}
```

## Step 2 — Generate Skeleton Step Definitions (PENDING only)
For each `.feature` file, generate a step definition class with ALL steps as `@Pending`:

```java
// src/test/java/<base-package>/steps/<Domain>Steps.java
public class <Domain>Steps {

    // Will be wired to Spring context via CucumberSpringContext
    @LocalServerPort
    private int port;

    @Given("<exact step text from feature>")
    public void <methodName>() {
        throw new io.cucumber.java.PendingException();
    }

    @When("<exact step text from feature>")
    public void <methodName>() {
        throw new io.cucumber.java.PendingException();
    }

    @Then("<exact step text from feature>")
    public void <methodName>() {
        throw new io.cucumber.java.PendingException();
    }
}
```

## Step 3 — Confirm RED
Run: `./mvnw test -Dtest=CucumberIT`
Expected result: ALL scenarios PENDING or FAILING. 
If anything passes: STOP — the scenario is already implemented or the step is not connected.

Document the red state:
```
RED STATE CONFIRMED — <date>
Feature: <feature-id>
Failing scenarios: <n>/<n>
```

## Step 4 — Implement Steps Against Domain Interface
Now implement step definitions using RestAssured (for HTTP) or direct service calls.
Steps should call the application EXTERNALLY (through HTTP) or through the service interface.
Steps MUST NOT directly access repositories or internal Spring beans (that bypasses the acceptance test purpose).

```java
@When("the customer places an order for {string}")
public void theCustomerPlacesAnOrderFor(String productName) {
    this.response = RestAssured
        .given()
            .port(port)
            .contentType(ContentType.JSON)
            .body(Map.of("product", productName))
        .when()
            .post("/api/orders")
        .then()
            .extract().response();
}

@Then("the order should be confirmed")
public void theOrderShouldBeConfirmed() {
    response.then().statusCode(201);
    response.then().body("status", equalTo("CONFIRMED"));
}
```

## Step 5 — Verify Still RED (Steps Implemented, Logic Not Yet)
Run again: `./mvnw test -Dtest=CucumberIT`
Now scenarios should FAIL (not PENDING) because steps are wired but implementation doesn't exist.
This is the true RED state. Document it.

## Step 6 — Hand Off to TDD
After the outer acceptance tests are RED and wired:
- Invoke the `tdd-red-green-refactor` skill
- Pass the Feature Card and failing acceptance test output as context
- Say: "Outer acceptance tests are RED. Now begin TDD inner cycle to make them GREEN."

## Page Object Pattern for Web UI Acceptance Tests
If testing a web UI via Selenium:
```
src/test/java/<base-package>/pages/<Domain>Page.java
```
Page Objects encapsulate all element locators and interaction methods.
Step definitions call Page Objects, never WebDriver directly.
