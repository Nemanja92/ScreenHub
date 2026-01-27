# ScreenHub

ScreenHub is a small SwiftUI demo app focused on a common real-world problem:  
**building a paginated movie list using async/await with clean, testable architecture**.

The goal of this project is not feature completeness, but clarity:
- how data flows through the app
- how async state is managed
- how common SwiftUI pitfalls are avoided

---

## What the app does

- Displays a list of movies fetched from a paged API
- Supports infinite scrolling (pagination)
- Shows a movie details screen
- Uses SwiftUI + async/await throughout
- Includes focused Swift Testing coverage for pagination logic

The backend is intentionally simple and served via static JSON files, with pagination handled through page-specific endpoints.

---

## Architecture overview

The project follows a **lightweight Clean Architecture** approach:
View → ViewModel → Use Case → Repository → Remote Data Source → HTTP Client

### Why this structure?

- Keeps UI code simple and declarative
- Isolates async and pagination logic in the ViewModel
- Makes data access testable and replaceable
- Scales naturally if more features or data sources are added

Even though the app itself is small, this structure mirrors patterns commonly used in production apps.

---

## Dependency injection

Dependencies are wired using a **factory-style composition root** (`CompositionRoot.swift`).

This keeps dependencies:
- explicit
- easy to follow
- free of global state or heavy DI containers

For a small app, this may look slightly more structured than strictly necessary, but it demonstrates how the app would scale without introducing complexity early.

---

## Pagination behavior

- Pagination is triggered when the last list item appears
- Duplicate fetches are prevented using internal loading guards
- The initial load is protected with a `hasLoaded` guard to avoid unintended reloads when navigating back from the details screen

Since the demo API returns plain lists (no paging metadata), pagination state is derived client-side. In a real backend-driven API, this information would typically be provided by the server.

---

## Testing

The project includes a small **Swift Testing** suite focused on:

- async pagination behavior
- view model state changes

UI rendering is intentionally excluded from tests to keep them:
- fast
- deterministic
- behavior-focused

This reflects how pagination and async state would typically be validated in a production codebase.

---

## Design trade-offs

Some intentional decisions made for this demo:

- **Single Movie model (no DTO yet)**  
  The API response matches UI needs closely. DTOs would be introduced once transformations or multiple data sources are needed.

- **No image caching layer**  
  `AsyncImage` is sufficient for a demo. A real app would use a dedicated image cache.

- **Minimal error handling UI**  
  Error handling is present but kept simple to avoid distracting from core logic.

---

## Potential improvements

If this were to evolve further, the next steps would likely be:

- Introduce DTOs and mapping
- Add image caching and prefetching
- Expand test coverage to include error and cancellation scenarios
- Support filtering and task cancellation using `.task(id:)`
- Add offline caching or persistence if required
- Add localization support
- Extract navigation logic into a dedicated coordinator if navigation complexity grows

---

## Summary

This project is intentionally small, but built with production patterns in mind.
The focus is on:
- clean data flow
- safe async handling
- predictable SwiftUI behavior

It is designed to be easy to read, easy to reason about, and easy to extend.

