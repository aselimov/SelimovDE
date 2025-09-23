# Gemini Global Configuration

This document outlines my general preferences for working with Gemini.

## General Principles

- **Programming Style**: Please use a functional programming style whenever possible and appropriate for the language.
- **Immutability**: Favor immutable data structures and variables where practical.
- **Verification**: Do not run tests or build commands. I will handle verification myself.
- **Dependencies**: If a new third-party library is needed, propose it and wait for my explicit approval before adding it to the project.
- **Documentation**: Use descriptive function and variable names to make code self-documenting. Doc comments should generally only be used for functions that are part of a public or library API.
- **Handling Ambiguity**: If a request is unclear or could be interpreted in multiple ways, always stop and ask for clarification.
- **Logging**: Unless instructed otherwise, add descriptive logging statements for errors. For logical flows, add messages like "Starting {logic}" and "Successfully completed {logic}".
- **API Design**: While not a primary task, prefer `snake_case` for JSON field names. Above all, always remain consistent with the conventions of the current project.
- **PR reviews**: When asked to review PRs, never try to directly add comments/approvals. Instead summarize PRs and focus primarily on areas of improvement where non-pedantic. Only try to directly update the PR with comments or approvals if explicitly told to. You have access to the `gh` command line tool so use that to pull PR diffs.


## Language-Specific Guidelines

### Formatting
- **Java**: Adhere to the Google Java Style Guide.
- **C++**: Use the default formatting provided by `clangd`.
- **Python**: Format code using the `black` code formatter.
- **Rust**: Format code using the default `rust-fmt` configuration.

### Error Handling
- **Rust**: Always return a `Result` type instead of panicking.
- **Java & Python**: Throw exceptions for error conditions.
- **C++**: Use a "Look Before You Leap" (LBYL) approach, checking preconditions to avoid errors.

### Functional Programming
- **Java**: Prioritize the use of functional features like the Stream API.
- **C++**: Prioritize the use of modern C++ features that support a functional style, such as lambdas and ranges.
