---
name: debug
description: Invoke systematic Spring Boot debugging on a failing test, exception, or unexpected behaviour. Classifies the failure type and applies the correct diagnostic process.
usage: /rushee:debug [test name | error description | stack trace]
example: /rushee:debug "OrderServiceTest#placeOrder_emptyCart fails with NullPointerException"
example: /rushee:debug "BeanCreationException on startup"
example: /rushee:debug "LazyInitializationException in OrderController"
---

Invoke the **debugger** agent to systematically diagnose and fix the failure.

This command:
1. Classifies the failure (Spring wiring / JPA / assertion / NPE / Cucumber / HTTP)
2. Applies the targeted diagnostic process for that category
3. Forms a hypothesis before touching any code
4. Proposes the minimal fix
5. Verifies the fix by running the test again

**When to use**: Any time a test fails or an exception is thrown.
Never change code based on a guess — always classify first.

**Rule enforced**: No code changes without a written hypothesis.
Read the full stack trace. Identify the category. Then fix.
