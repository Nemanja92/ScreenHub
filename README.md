# ScreenHub

ScreenHub is a small iOS demo app for browsing a paginated list of movies, viewing details for each title, and refining results with local search and filtering.

The goal of the project is not feature breadth, but to demonstrate a clean, readable SwiftUI codebase with layered architecture, async data loading, pagination, error handling, lightweight dependency injection, and testable screen logic.

<p align="center">
  <img src="Screenshots/screenhub-home.gif" alt="ScreenHub home demo" width="220" />
</p>

## Highlights

- SwiftUI-based UI
- Observation-based presentation layer using `@Observable` and `@Bindable`
- Layered architecture across Presentation, Domain, and Data
- Dependency injection through a lightweight composition root
- Async/await-based networking
- Paginated loading with server-provided paging metadata
- Separate handling for initial load failures and next-page failures
- Pull to refresh
- Local movie search with debounce
- Minimum rating filter via sheet-based UI
- No-results state for active search and filter combinations
- Unit tests for view model flows and domain use cases

## Features

- Browse a paginated list of movies
- View movie details
- Search within the currently loaded results
- Filter movies by minimum rating
- Refresh the list
- Retry failed initial load
- Retry failed next-page load without losing already visible content

## Architecture

The project is intentionally split into a few small layers to keep responsibilities clear and the code easy to follow:

- **Presentation** contains SwiftUI views and view models
- **Domain** contains core models, repository contracts, and use cases
- **Data** contains the API layer, remote data source, repository implementation, and infrastructure concerns

This keeps the flow straightforward:

- the view triggers the view model
- the view model uses use cases
- the use cases call the repository
- the repository uses the remote data source
- the remote data source calls the API client

## Key Parts

- `CompositionRoot.swift`  
  Wires the feature together and creates the dependency graph

- `MoviesListViewModel.swift`  
  Manages initial loading, refresh, pagination, search debounce, filtering, and retry behavior

- `MoviesListView.swift`  
  Renders loading, error, empty, and content states, along with search and filter UI

- `SearchMovieUseCase.swift`  
  Filters the currently loaded movie list by title query

- `FilterMovieUseCase.swift`  
  Filters the currently loaded movie list by minimum rating

- `MoviesAPI.swift`  
  Fetches and decodes paginated movie responses

- `MoviesRemoteDataSource.swift`  
  Provides a small abstraction over the remote API layer

- `MoviesRepository.swift`  
  Exposes paginated movie fetching to the domain layer

## Search and Filtering

Search and filtering are handled locally in the presentation/domain flow rather than through a dedicated backend search endpoint.

The current behavior is:

- the app loads paginated movie data from the backend
- loaded pages are stored in memory
- filtering is applied first
- search is then applied to the filtered results
- the visible list is recomputed whenever loaded data, search text, or filter state changes

Search input uses a small debounce to avoid recomputing on every keystroke.

### Current trade-off

Search and filtering currently operate on **loaded pages only**, not on the full remote dataset.

That means:

- results are fast and simple to compute locally
- the implementation stays lightweight and easy to review
- a movie that exists only on a page that has not been loaded yet will not appear in search results yet

For a larger production app, I would likely introduce a backend-supported search endpoint and paginate search results separately.

## Pagination

For the demo API, the app uses static JSON files hosted in a separate repo: [screenhub-demo-api](https://github.com/Nemanja92/screenhub-demo-api/).

Each response returns:

- `page`
- `hasNextPage`
- `movies`

This allows the app to stop pagination based on server metadata instead of relying on a hardcoded max page in the client.

## Error Handling

The app treats the two main failure scenarios differently:

- **Initial load failure** shows a full-screen error state with retry
- **Next page failure** keeps already loaded content on screen and shows retry UI at the bottom of the list

This makes the pagination behavior feel closer to a real product experience.

## State Handling

The list screen supports several distinct UI states:

- initial loading
- initial load failure
- loaded content
- loading next page
- next-page failure with inline retry
- no results for active search/filter criteria

The view model keeps the source data and visible data separate:

- `allMovies` stores the currently loaded pages
- `movies` stores the filtered and searched results shown in the UI

This keeps search and filter logic clear and makes recomputation straightforward.

## Testing

The included tests cover both screen logic and domain logic.

### View model tests
The view model tests focus on flows such as:

- initial page loading
- loading the next page when the last item appears
- stopping pagination when there are no more pages
- keeping already loaded content when next-page loading fails
- retrying the initial load after failure
- search behavior after debounce
- using the latest query when typing quickly

### Use case tests
Separate unit tests cover:

- search behavior for empty and non-empty queries
- case-insensitive title matching
- minimum rating filtering behavior
- keeping items that match the filter boundary exactly

## Trade-offs

A few implementation decisions are intentionally lightweight to keep the project focused and easy to review:

- **`Movie` is used both as the decoded API model and the app model**  
  For a small demo, this keeps the code simpler and avoids introducing DTO-to-domain mapping noise. In a larger production system, I would likely separate remote DTOs from domain models once API-specific concerns start diverging from app-facing needs.

- **Image loading is intentionally simple**  
  Poster images are loaded directly in the UI layer. A production app would likely use a more explicit image pipeline or caching strategy where appropriate for better control over memory usage, caching behavior, placeholders, and request deduplication.

- **Search and filtering are local over loaded pages**  
  This keeps the implementation simple and testable, but it is not a substitute for full backend-powered dataset search.

- **The demo backend uses static JSON files**  
  This keeps the project easy to run and review while still demonstrating a realistic paginated contract and async loading flow.

- **The architecture is lightweight by design**  
  The project uses clear boundaries and dependency injection, but avoids adding complexity that would not provide much value for a small demo.

## Why This Project

This project was built as a focused demo to show:

- clean layering and dependency flow
- practical SwiftUI state management using Observation
- pagination driven by server response metadata
- local search and filtering without overcomplicating the architecture
- clear retry behavior for different failure scenarios
- testable screen logic and domain logic without over-engineering

## Possible Next Steps

A few natural improvements I would consider if this were expanded further:

- add a backend-supported search endpoint and search pagination
- expose active filter state more prominently in the UI
- add explicit filter reset affordances
- introduce a more explicit image caching pipeline where it provides clear value
- separate API DTOs from app-facing domain models if the contract grows more complex
- add persistence or offline support if the product requirements called for it

## Notes

This is intentionally a small demo project. It keeps the architecture clear and the feature set focused so the loading flow, dependency structure, search/filter behavior, and error handling can be reviewed quickly without unnecessary framework or infrastructure noise.
