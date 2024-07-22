# Fetcher

*   Install dependencies

    ```sh
    bundle install
    ```

*   Configure environment

    ```sh
    cp config/database.yml{.dist,}
    cp .env{.dist,} && echo "PROJECT_NAME=${PWD##*/}" >> .env
    ```

*   Create and setup database

    ```sh
    bundle exec rake db:create
    bundle exec rake db:migrate
    ```

*   Start web server

    ```sh
    bundle exec rackup -s puma -o 0.0.0.0 -p 5678
    ```

*   Start sidekiq server

    ```sh
    bundle exec sidekiq -r ./config/environment.rb -C config/sidekiq.yml
    ```
