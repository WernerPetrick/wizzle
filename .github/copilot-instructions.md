# Project Architecture

- **Framework**: Ruby on Rails 8+ with Hotwire (Turbo + Stimulus) for frontend interactivity.
- **Database**: PostgreSQL
- **Deployment**: Auto-deploys to [Render](https://render.com/) on push to `main`.
- **Authentication**: Custom solution (not using Devise).
- **Styling**: Custom CSS, no framework (e.g. no Tailwind or Bootstrap).
- **Frontend Rendering**: Server-rendered HTML using Turbo Frames and Turbo Streams.
- **Directory Structure**: Follows standard Rails conventions.

# Developer Workflows

- **Branching Strategy**: Feature branches off `main`, merged via PRs.
- **Deployments**: Automatically triggered on `main` push via Render.
- **Testing**: No test suite implemented yet — testing is planned.
- **Code Style**: Follows Ruby and Rails idioms; consistent naming encouraged.
- **Asset Management**: Custom CSS is stored in `app/assets/stylesheets`.

# Project-Specific Patterns

- **Wishlists**  
  Core feature. Wishlists can be:
  - Public or private
  - Shared via `SharedWishlist`
  - Composed of multiple `WishlistItem`s
  - Annotated with `WishlistItemNote`s

- **Communities**  
  Users can:
  - Belong to multiple `Community` records
  - See each other’s wishlists if in the same community (regardless of friendship)
  - Be invited via `CommunityInvitation`
  - Participate in optional `CommunityEvent`s

- **Friends**  
  Managed using the `Friendship` model.  
  Enables private visibility and collaboration.

- **Gifting Workflow**  
  Tracked using `GiftHistory`.  
  Indicates if and when a `WishlistItem` was claimed.

- **Invites**  
  - One-on-one invites handled with `Invitation`
  - Community invites handled with `CommunityInvitation`

- **Blog**  
  Content managed via `BlogPost` model.  
  Used for updates and inspiration.

- **Roadmap**  
  Public product roadmap managed using `RoadmapItem`.

# Guidelines for GitHub Copilot

- Suggest Stimulus controllers using the convention: `x_controller.js` inside `app/javascript/controllers`.
- Avoid React/Vue suggestions — the frontend is Rails + Turbo only.
- Use `.html.erb` views and prefer Turbo Frames/Streams when updating content.
- Suggest:
  - Validations
  - Named scopes
  - Proper ActiveRecord associations
- Favor partials for shared UI (e.g., wishlist cards, profile blocks).

# Future Enhancements (Planned)

- Extract reusable partials/components for wishlist items and user display.
- Implement RSpec or Minitest for models and system tests.
- Add simple notification/logging system using Turbo Streams.
- Extend communities with discussion/chat or shared event coordination.

## Conventions

### General

- **Rails Conventions**: Follow standard Rails idioms for directory structure, naming, and architecture. Prefer convention over configuration.
- **Sandi Metz’s Rules** (adapted):
  - Classes should be no longer than 100 lines.
  - Methods should be no longer than 5 lines.
  - Pass no more than 4 parameters (including options hash).
  - Controllers should instantiate only one object and delegate to it.
  - Favor composition over inheritance where appropriate.
- **Code Style**:
  - Use snake_case for variables and methods, CamelCase for classes.
  - Prefer early returns and guard clauses to reduce nesting.
  - Use `before_action`, `private` methods, and strong parameters in controllers.
  - Favor `.each` and `.map` over `for` loops.
  - Avoid logic in views; use view helpers or presenters where needed.

### Models

- Use validations, scopes, and `enum` where applicable.
- Keep models lean; extract service objects for complex logic.
- Use meaningful associations (`has_many`, `belongs_to`, etc.) with dependent options when necessary.

### Views

- Use partials for reusable UI blocks (e.g., wishlist cards, user avatars).
- Use Turbo Frames/Streams for partial page updates.
- Avoid embedding business logic in views.

### JavaScript / Stimulus

- Stimulus controllers live in `app/javascript/controllers`
- Use one Stimulus controller per feature/unit of interactivity.
- Keep DOM manipulation minimal; rely on Turbo where possible.

### Git

- Use descriptive branch names (e.g., `feature/community-events`, `fix/invite-link-bug`).
- Write clear commit messages (imperative tense, e.g., “Add ability to…”).

### Misc

- Use singular table names in model relationships.
- Prefer POROs for background business logic if it doesn’t fit in a model.
- Don’t reinvent what Rails already provides (e.g., use `has_secure_password`, `enum`, etc.).

