# Anthropic Prompt Engineering Core Guide

## 1. Clarity & Directness (be-clear-and-direct)
- Explicitly define Role, Goal, and Output Format
- Avoid vague instructions ("do it well" → "write a summary under 500 characters")
- Use positive directives ("do X" instead of "don't do Y" where possible)
- Scoring: Role defined (5), Goal defined (5), Output format (5), Constraints (5) = 20 pts

## 2. Multishot Prompting (multishot-prompting)
- Include 2+ input/output examples to significantly boost performance
- Examples should closely resemble real use cases
- Include edge case examples where applicable
- Scoring: No examples (0), 1 example (7), 2+ examples (12), Edge cases included (15)

## 3. Chain-of-Thought (chain-of-thought)
- Use phrases like "think step by step" or "first analyze X, then derive Y"
- CoT is essential for complex, multi-step tasks
- Explicitly request intermediate reasoning steps
- Scoring: No CoT (0), Implicit (7), Explicit (12), Structured CoT (15)

## 4. XML Tag Structuring (use-xml-tags)
- Separate input data, instructions, and output format using XML tags
- Use meaningful, consistent tag names
- Use nested tags to represent hierarchical structure
- Scoring: No tags (0), Partial use (7), Systematic use (12), Nested structure (15)

## 5. System Prompts (system-prompts)
- Define role and persona in the system prompt
- Separate global rules from task-specific instructions
- Include security and safety guidelines where applicable
- Scoring: Quality of system prompt design (10 pts)

## 6. Prompt Chaining (chain-prompts)
- Break complex tasks into sequential sub-tasks
- Use the output of one step as the input for the next
- Include validation checkpoints between steps
- Scoring: Single step (0–5), 2-step chain (7), 3+ step chain (10)

## 7. Long Context Handling (long-context-tips)
- Place key information at the beginning and/or end of the prompt
- Summarize long documents before referencing them
- Design chunking strategies that respect context window limits
- Scoring: Not considered (0), Partially considered (3), Well considered (5)

## 8. Extended Thinking (extended-thinking-tips)
- Explicitly request deep reasoning for complex tasks
- Use phrases like "consider all possibilities" or "thoroughly analyze pros and cons"
- Encourage thorough reasoning before reaching a conclusion
- Scoring: Not applicable (5), Implicit (7), Explicitly utilized (10)

---

## Score Interpretation
- 90–100: Fully optimized, ready to use immediately
- 85–89: Excellent, ready to use (target threshold)
- 70–84: Good, 1–2 additional improvement cycles recommended
- 50–69: Average, key areas need improvement
- Below 50: Full rewrite recommended