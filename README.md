# ScreenHub

ScreenHub is a small iOS demo app for browsing a paginated list of movies and viewing basic details for each title.

The goal of the project is not feature breadth, but to demonstrate a clean, readable SwiftUI codebase with layered architecture, async data loading, pagination, error handling, and a lightweight composition root.

<p align="center">
  <img src="Screenshots/screenhub-home.gif" alt="ScreenHub home demo" width="220" />
</p>

## Highlights

- SwiftUI-based UI
- Layered architecture across Presentation, Domain, and Data
- Dependency injection through a lightweight composition root
- Async/await-based networking
- Paginated loading with server-provided paging metadata
- Separate handling for initial load failures and next-page failures
- Unit tests for key view model pagination flows

## Architecture

The project is intentionally split into a few small layers to keep responsibilities clear and the code easy to follow:

- **Presentation** contains SwiftUI views and view models
- **Domain** contains core models, repository contracts, and use cases
- **Data** contains the API layer, remote data source, repository implementation, and infrastructure concerns

This keeps the flow straightforward:

- the view triggers the view model
- the view model uses a use case
- the use case calls the repository
- the repository uses the remote data source
- the remote data source calls the API client

## Pagination

For the demo API, the app uses static JSON files hosted in a separate repo: [screenhub-demo-api](https://github.com/Nemanja92/screenhub-demo-api/).

Each response returns:

- `page`
- `hasNextPage`
- `movies`

This allows the app to stop pagination based on server metadata instead of relying on a hardcoded max page in the client.

## Key Parts

- `CompositionRoot.swift`  
  Wires the feature together and creates the dependency graph

- `MoviesListViewModel.swift`  
  Manages initial loading, next-page loading, and retry behavior

- `MoviesAPI.swift`  
  Fetches and decodes paginated movie responses

- `MoviesRemoteDataSource.swift`  
  Provides a small abstraction over the remote API layer

- `MoviesRepository.swift`  
  Exposes paginated movie fetching to the domain layer

- `MoviesListView.swift`  
  Renders the list, full-screen loading/error states, and the next-page loading/error footer

## Error Handling

The app treats the two main failure scenarios differently:

- **Initial load failure** shows a full-screen error state with retry
- **Next page failure** keeps already loaded content on screen and shows retry UI at the bottom of the list

This makes the pagination behavior feel closer to a real product experience.

## Testing

The included tests focus on view model behavior, including:

- initial page loading
- loading the next page when the last item appears
- stopping pagination when there are no more pages
- keeping already loaded content when next-page loading fails
- retrying the initial load after failure

## Trade-offs

A few implementation decisions are intentionally lightweight to keep the project focused and easy to review:

- **`Movie` is used both as the decoded API model and the app model**  
  For a small demo, this keeps the code simpler and avoids introducing DTO-to-domain mapping noise. In a larger production system, I would likely separate remote DTOs from domain models once API-specific concerns start diverging from app-facing needs.

- **Image loading is intentionally simple**  
  Poster images are loaded directly in the UI layer. A production app would likely use a more explicit image pipeline or caching strategy where appropriate for better control over memory usage, caching behavior, placeholders, and request deduplication.

- **The demo backend uses static JSON files**  
  This keeps the project easy to run and review while still demonstrating a realistic paginated contract and async loading flow.

- **The architecture is lightweight by design**  
  The project uses clear boundaries and dependency injection, but avoids adding complexity that would not provide much value for a small demo.

## Why This Project

This project was built as a focused demo to show:

- clean layering and dependency flow
- pagination driven by server response metadata
- practical async state handling in SwiftUI
- clear retry behavior for different failure scenarios
- testable screen logic without over-engineering

## Possible Next Steps

A few natural improvements I would consider if this were expanded further:

- add pull to refresh
- add search support
- introduce a more explicit image caching pipeline where it provides clear value
- separate API DTOs from app-facing domain models if the contract grows more complex
- add persistence or offline support if the product requirements called for it

## Notes

This is intentionally a small demo project. It avoids persistence, offline support, advanced search/filtering, pull to refresh, and a dedicated image caching pipeline so the core architecture and loading flow remain easy to review at a glance.
