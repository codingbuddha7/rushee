#!/usr/bin/env bash
# guard-domain-purity.sh
# Blocks Jakarta Persistence / Spring annotations being written into domain layer classes

FILE_PATH="$1"
FILE_CONTENT="$2"

# Only check domain layer Java files
if [[ "$FILE_PATH" == *"/domain/"* ]] && [[ "$FILE_PATH" == *".java" ]]; then

  # Check for JPA annotations
  if echo "$FILE_CONTENT" | grep -qE "@Entity|@Table|@Column|@Id|@GeneratedValue|@ManyToOne|@OneToMany|@ManyToMany|@OneToOne|@JoinColumn|@Embeddable|@Embedded"; then
    echo "❌ ARCHITECTURE VIOLATION: JPA annotation detected in domain layer."
    echo "   File: $FILE_PATH"
    echo ""
    echo "   Domain classes must be pure Java — no Jakarta Persistence imports."
    echo "   Create a separate JPA entity in infrastructure/persistence/ and a mapper."
    echo ""
    echo "   See skill: clean-architecture-ports-adapters"
    echo "   The Dependency Rule: domain knows nothing about infrastructure."
    echo ""
    echo "   💡 Teachable moment: This suggests you may need to review Hexagonal"
    echo "   Architecture / DDD domain purity. Ask: \"Explain why domain classes must"
    echo "   not use @Entity\" or say \"Explain domain purity and ports and adapters\" —"
    echo "   then continue with the same skill for the correct pattern."
    exit 1
  fi

  # Check for Spring annotations
  if echo "$FILE_CONTENT" | grep -qE "@Service|@Component|@Repository|@Controller|@RestController|@Autowired|@Value\b"; then
    echo "❌ ARCHITECTURE VIOLATION: Spring annotation detected in domain layer."
    echo "   File: $FILE_PATH"
    echo ""
    echo "   Domain classes must be pure Java — no Spring framework imports."
    echo "   Spring wiring belongs in the infrastructure or application layer."
    echo ""
    echo "   See skill: clean-architecture-ports-adapters"
    echo ""
    echo "   💡 Teachable moment: You may need to review Hexagonal Architecture /"
    echo "   DDD domain purity. Ask: \"Explain why domain must not use @Service\" or"
    echo "   \"Explain ports and adapters\" — then continue with the same skill."
    exit 1
  fi

fi

exit 0