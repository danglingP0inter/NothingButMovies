# Nothing but Movies!

There is no pod dependancy. So, you can just build and run the project.


## Architecture

This project follows MVVM architecture.

## Features Implemented

 - **Home Tab** - Shows the now playing movies using TMDb api. This page supports pagination. Once user scrolls to the bottom of page, a new request is made to fetch next set of movies.
 - **Movie Details Page** - Shows the movie details like title, tagline, runtime, genre, language etc. User can also share and add/remove the movie from favourites on this page. Movies marked as favourites are saved in Document Directory (Cache) folder. Movies marked as favorites can be viewed under "Favourites" tab.
 -   **Search Tab** - User can search for a movie and can go to details page on tap of a search result item. The concept of throttling has been used here to avoid cluttering the network requests.
 - **Share** - User can share a movie by clicking on top right button on movie details page. It shares a deeplink corresponding to that movie. This deeplink has been used to directly navigate to that specific movie detail page.
 - **Caching** - Movie posters are cached using NSCache and items marked as favourites are cached in document cache folder.
 - **View Model** - As this project follows MVVM architecture, each view controller has a view model that has the responsibility of data manipulation to be presented on view and making the network/cached data request.

## Features Not Implemented

 - **Core data** - This project doesn't have an offline support using core data.
 - **Error handling** - Handling is not done for no network case, no data from api response or api failure case. There are functions for these cases in each view controller but implementation is not done.
 - **Cache Expiry** - No TTL set for cache.
 - **Placeholder** - No placeholder is set if image downloading gets failed for a movie.

## 

Made with ❤️ and Swift 
