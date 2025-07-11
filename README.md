# Wizzle

[!NOTE]
As part of a challenge, this project was entirely vibe coded using Github Copilot and Builder.io

Wizzle is a social wishlist web application built with Ruby on Rails. It allows users to create wishlists, share them with friends, ask and answer questions about wishlist items, and track gift history. The app supports friend invitations (including inviting non-users), notifications, and inline editing for a smooth user experience.

## Features

- **Wishlists:** Create, edit, and delete wishlists and wishlist items.
- **Sharing:** Share wishlists with friends via email invitations.
- **Friends:** Invite friends (users and non-users), accept/decline invitations, and manage your friends list.
- **Questions & Notes:** Ask anonymous questions about wishlist items; owners can reply and both parties are notified via email.
- **Gift History:** Track gifts you’ve bought for friends.
- **Email Integration:** Email notifications for invitations and questions using [letter_opener](https://github.com/ryanb/letter_opener) in development..

## Getting Started

### Prerequisites

- Ruby 3.3.0
- Rails 8.0.2
- SQLite (Turso)
- Bundler

### Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/wizzle.git
   cd wizzle
   ```

2. **Install dependencies:**
   ```sh
   bundle install
   ```

3. **Set up the database:**
   ```sh
   bin/rails db:create db:migrate
   ```

4. **Start the server:**
   ```sh
   bin/rails server
   ```

5. **Access the app:**
   Open [http://localhost:3000](http://localhost:3000) in your browser.

### Email (Development)

- Emails are previewed in your browser using `letter_opener`.
- Make sure your `config/environments/development.rb` includes:
  ```ruby
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  ```

## Usage

- **Sign up** and create your first wishlist.
- **Invite friends** by email. Non-users will receive a signup link.
- **Accept or decline invitations** from the Friends page.
- **Share wishlists** and ask questions about items.
- **Reply to questions** and receive notifications.
- **Track your gift history** from your profile.

## Contributing

Pull requests are welcome!

## License

MIT

---
