---
name: security-check
description: Run a full security review on a feature or set of changed files. Covers OWASP Top 10, Spring Security config, input validation, secrets, and access control.
usage: /rushee:security-check [FDD-NNN | path]
example: /rushee:security-check FDD-005
example: /rushee:security-check src/main/java/com/myapp/order/
---

**Skills needed for this phase:** OWASP Top 10, auth (JWT/OAuth2), input validation, mobile security (secure storage, pinning). Rushee skills: security-by-design, mobile-security-by-design.
**New to this?** Say: "What should I check for security?" — then we'll run the security-reviewer.

Invoke the **security-reviewer** agent to perform a security gate review.

This command:
1. Scans all specified files (or feature-related files if FDD given)
2. Runs automated secret and injection scans
3. Applies the full OWASP A01–A10 checklist
4. Produces a structured finding report with severity ratings
5. Outputs APPROVED or CHANGES REQUIRED

**When to use**:
- Before any feature touches authentication, authorisation, or user data
- As part of `/rushee:status` final review gate
- Anytime you want to verify a security posture

**Output**:
- Security review report (console)
- Saved to `docs/reviews/<FDD-NNN>-security.md`

**Severities**: CRITICAL (blocks merge immediately) / HIGH / MEDIUM / LOW
